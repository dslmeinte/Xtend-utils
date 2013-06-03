package nl.dslmeinte.xtend.annotations

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.AbstractFieldProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableAnnotationTarget
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

@Active(typeof(ParametrizedInjectionProcessor))
@Target(ElementType::TYPE)
annotation ParametrizedInjected {}

@Active(typeof(ClassParameterChecker))
@Target(ElementType::FIELD)
annotation ClassParameter {}

@Target(ElementType::METHOD)
annotation Initialisation {}

class ParametrizedInjectionProcessor extends AbstractClassProcessor {

	override doTransform(MutableClassDeclaration it, extension TransformationContext context) {
		val classParameters = declaredFields.filterAnnotatedWith(typeof(ClassParameter))
		if( classParameters.empty ) {
			addError('''class «simpleName» must have @«typeof(ClassParameter).simpleName»s''')
		}

		val initialisations = declaredMethods.filterAnnotatedWith(typeof(Initialisation))
		initialisations.forEach[ m |
			if( !m.parameters.empty ) {
				addError('''@Initialisation method «m.simpleName» cannot have parameters''')
			}
		]
		val realInitialisations = initialisations.filter[parameters.empty]

		addConstructor[
			classParameters.forEach[ f | addParameter(f.simpleName, f.type)]
			addParameter("_injector", "com.google.inject.Injector".newTypeReference)	// avoid having Guice as a dependency of this bundle
			body = [
				'''
				_injector.injectMembers(this);
				«FOR f : classParameters»
					this.«f.simpleName» = «f.simpleName»;
				«ENDFOR»
				«FOR m : realInitialisations»
					«m.simpleName»();
				«ENDFOR»
				'''
			]
		]
		// TODO  make the fields final (produces an error in source now)
		//	classParameters.forEach[final = true]

		realInitialisations.forEach[visibility = Visibility::PROTECTED]

		if( declaredFields.filter[annotations.exists[ annotationTypeDeclaration.qualifiedName == 'com.google.inject.Inject' ]].empty ) {
			addWarning('''class «simpleName» has no @Inject-ed fields: you could use @Data & @Property instead of @ParametrizedInjected & @ClassParameter''')
		}
	}

	def private <T extends MutableAnnotationTarget> filterAnnotatedWith(Iterable<T> targets, Class<?> annotationJavaType) {
		targets.filter[annotations.exists[ annotationTypeDeclaration.qualifiedName == annotationJavaType.name ]]		// TODO  find more elegant way to this filtering
	}

	// TODO  generate a SingleMethodObject builder class for passing the required data into the constructor

}


class ClassParameterChecker extends AbstractFieldProcessor {

	override doTransform(MutableFieldDeclaration it, extension TransformationContext context) {
		if( !declaringType.annotations.exists[ a | a.annotationTypeDeclaration.qualifiedName == typeof(ParametrizedInjected).name ] ) {
			addError('''@«typeof(ClassParameter).simpleName» can only be used inside a @«typeof(ParametrizedInjected).simpleName» class''')
		}
	}

}
