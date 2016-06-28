module UserFactory
  def self.build(params = {})
    u = User.new(
      { pof_username: "foo",
        pof_password: "bar",
        name: "baz" }.merge(params)
    )
    u.profile = ProfileFactory.create
    u
  end

  def self.create(params = {})
    u = build(params)
    u.save!
    u
  end
end
