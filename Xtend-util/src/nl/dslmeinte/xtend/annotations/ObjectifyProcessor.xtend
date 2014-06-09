package nl.dslmeinte.xtend.annotations

import java.io.Serializable
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

@Active(typeof(ObjectifyProcessor))
@Target(ElementType.TYPE)
annotation ObjectifyEntity {}

class ObjectifyProcessor extends AbstractClassProcessor {

	override doTransform(MutableClassDeclaration it, extension TransformationContext context) {
		addAnnotation("com.googlecode.objectify.annotation.Entity".newAnnotationReference)
		addAnnotation("com.googlecode.objectify.annotation.Cache".newAnnotationReference)
		addAnnotation("java.lang.SuppressWarnings".newAnnotationReference[
			setStringValue("value", "serial")
		])
		implementedInterfaces = #[ typeof(Serializable).newTypeReference ]

		declaredFields.forEach[ f | f.visibility = Visibility.PUBLIC ]
	}
	
}
