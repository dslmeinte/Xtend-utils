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
@Target(ElementType::TYPE)
annotation ObjectifyEntity {}

class ObjectifyProcessor extends AbstractClassProcessor {

	override doTransform(MutableClassDeclaration it, extension TransformationContext context) {
		addAnnotation("com.googlecode.objectify.annotation.Entity".newTypeReference.type)
		addAnnotation("com.googlecode.objectify.annotation.Cache".newTypeReference.type)
		addAnnotation("java.lang.SuppressWarnings".newTypeReference.type).set("value", "serial")
		implementedInterfaces += typeof(Serializable).newTypeReference	// FIXME  doesn't work...

		declaredFields.forEach[ f | f.visibility = Visibility::PUBLIC ]
	}
	
}
