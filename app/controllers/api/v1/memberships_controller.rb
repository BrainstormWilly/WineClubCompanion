class Api::V1::MembershipsController < Api::V1::BaseController

	def search
		if params[:q].empty?
			@memberships = policy_scope(Membership)
			return render json: @memberships, each_serializer: MembershipSerializer
		end
		u_memberships = policy_scope(Membership)
		s_memberships = Membership.search(params[:q]).records
	    @memberships = u_memberships & s_memberships
	    render json: @memberships, each_serializer: MembershipSerializer
	end

end