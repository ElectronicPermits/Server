class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    # Permissions for Trusted Apps
      case controller_namespace
        when 'manage'
          #TODO
          can :read, User if user_can(user, 
                                      UserPermission.READ, 
                                      UserPermission.USERS)

          can :create, User if user_can(user, 
                                        UserPermission.CREATE, 
                                        UserPermission.USERS)

          can :update, User if user_can(user,
                                        UserPermission.MODIFY, 
                                        UserPermission.USERS)

          can :destroy, User if user_can(user,
                                         UserPermission.DELETE, 
                                         UserPermission.USERS)

          can :manage, :all if user.has_role? 'admin'
        else
          #Permit ma
          can :destroy, User if user_can(user,
                                         UserPermission.DELETE, 
                                         UserPermission.USERS)
          # rules for non-admin controllers here

      end
  end

  private

  def user_can(user, action, target)
    user.user_permissions.each do |permission|
      if permission.target == target then
        if permission.action == action or 
          permission.action == UserPermission.ALL then
          return true
        end
      end
    end

    return false
  end

    return false
  end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
end
