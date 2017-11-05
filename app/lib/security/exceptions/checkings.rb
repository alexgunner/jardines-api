module Security::Exceptions::Checkings

	class TargetMethodNotDefined < StandardError
		def initialize
			super "Target method nod defined. Define at least one method to apply this checking to."
		end
	end
end