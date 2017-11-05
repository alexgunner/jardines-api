module EndpointExpectations

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def expect_endpoint endpoint, vars
			user = vars[:user]
			action = vars[:to]
			method = vars.has_key?(:method) ? vars[:method] : :get

			context "When user is #{user}" do

				before do 
					set_current_user self.send(user)
					self.send(method, eval("\""+endpoint+"\""))
				end
				
				self.send(action)
			end
		end

		def deny
			it "should deny operation" do
				expect(response.body).to match("Operation denied")
				expect(response).to have_http_status(403)
			end
		end

		def allow
			it "should allow operation" do
				expect(response).not_to have_http_status(403)
			end
		end
	end

end