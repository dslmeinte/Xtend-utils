package nl.dslmeinte.xtend.annotations

import org.eclipse.xtend.lib.macro.AbstractFieldProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration

@Active(typeof(GetterProcessor))
annotation Getter {}

class GetterProcessor extends AbstractFieldProcessor {

	override doTransform(MutableFieldDeclaration field, extension TransformationContext context) {
		field.declaringType.addMethod("get" + field.simpleName.toFirstUpper) [
			returnType = field.type
			body = [
				'''
				return this.«field.simpleName»;
				'''
			]	// TODO  make it an unmodifiable view
		]
	}

}
