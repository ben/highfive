module FakeSlack
  class UserInfo
    attr_reader :name, :real_name, :id, :email, :profile

    def initialize(name)
      @name = @real_name = @id = name
      @profile = UserProfile.new(name)
    end
  end

  class UserProfile
    attr_reader :email

    def initialize(emailbase)
      @email = "#{emailbase}@somewhere"
    end
  end
end
