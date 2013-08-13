package nl.dslmeinte.xtend.resources

import java.io.FileReader
import java.nio.CharBuffer

import static nl.dslmeinte.xtend.resources.ResourcesUtil.*

/**
 * Example usage of the try-with-resources implementation in Xtend: @{link nl.dslmeinte.xtend.resources.ResourcesUtil}.
 * <p>
 * Adapted from: http://matcherror.blogspot.nl/2013/08/implementing-try-with-resources-in-xtend.html
 * by John Kozlov.
 */
class ResourcesUtilExample {

	def static void main(String...args) {
		new ResourcesUtilExample().run
	}

	def run() {
		val text = using(new FileReader('build.properties')) [
			val buffer = CharBuffer::allocate(1024)
			read(buffer)
			buffer.rewind
			buffer.toString
		]

		println(text)
	}	

}
