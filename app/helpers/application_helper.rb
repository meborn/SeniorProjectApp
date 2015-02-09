module ApplicationHelper
	def user_namespace?
		controller.class.name.split("::").first == "User"
	end
end
