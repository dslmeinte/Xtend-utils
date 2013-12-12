package nl.dslmeinte.xtend.collections;

import java.util.Map;

import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function1;

/**
 * Wraps a {@link Map map} so that a call to {@link #eagerGet(Object)} creates a
 * value through the creation function passed to the constructor.
 * <p>
 * This is useful for when values are collections (multiple values for one key).
 */
public class EagerlyInitializingMap<K, V> {

	private Map<K, V> map;
	private Function1<K, V> creationFunction;

	public <T> EagerlyInitializingMap(final Map<K, V> map, final Function1<K, V> creationFunction) {
		this.map = map;
		this.creationFunction = creationFunction;
	}

	/**
	 * Sometimes, Xtend is not able to correctly infer that a creation closure
	 * takes no arguments so, so we also provide this constructor and then
	 * simply curry the function given.
	 */
	public <T> EagerlyInitializingMap(final Map<K, V> map, final Function0<V> creationFunction) {
		this(map, new Function1<K, V>() {
			@Override
			public V apply(K key) {
				return creationFunction.apply();
			}
		});
	}

	public V eagerGet(K key) {
		V value = map.get(key);
		if( value == null ) {
			value = creationFunction.apply(key);
			map.put(key, value);
		}
		return value;
	}

	public Map<K, V> getWrappedMap() {
		return map;
	}

}
