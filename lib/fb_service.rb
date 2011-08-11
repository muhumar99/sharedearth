module FbService

# Returns a list of all my authorized fb friends Personas
  def self.get_my_friends(token)
    registered_user = FbGraph::User.me(token)
    friend_list = []

    begin
      friends_list = registered_user.friends(options = {:access_token => token})  
    rescue
      puts "Access token was incorrect"
      return friend_list
    end

    unless friends_list.nil?
      friends_identifiers = friends_list.collect(&:identifier)

      user_list   = User.where(:uid => friends_identifiers)
      people_ids  = user_list.collect(&:person).collect(&:id)
      friend_list = Person.authorized.where(:id => people_ids)
    end

    friend_list
  end
end