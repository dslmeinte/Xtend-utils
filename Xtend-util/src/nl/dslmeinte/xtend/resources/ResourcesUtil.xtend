package nl.dslmeinte.xtend.resources

import java.io.Closeable

/**
 * Util class with implementation of try-with-resources in Xtend.
 * <p>
 * Adapted from: http://matcherror.blogspot.nl/2013/08/implementing-try-with-resources-in-xtend.html
 * by John Kozlov.
 * <p>
 * For an example of usage, see {@link ResourcesUtilExample}.
 */
class ResourcesUtil {

	/**
	 * Executes a procedure on a resource (i.e.: an object that's {@link Closeable})
	 * which takes care of closing the resource properly, even in case the procedure
	 * exits prematurely through an exception.
	 */
	def static <T extends Closeable, R> R using(T resource, (T)=>R procedure) {
		// this value is kept in case a Throwable from close() overwrites a Throwable from try {}:
		var Throwable mainThrowable
		try {
			procedure.apply(resource)
		} catch (Throwable t) {
			mainThrowable = t
			throw t
		} finally {
			if (mainThrowable === null) {
				resource.close
			} else {
				try {
					resource.close
				} catch (Throwable unused) {
					// (ignore because mainThrowable is present)
				}
			}
		}
	}

}
