module ProfileFactory
  def self.build(params = {})
    _build({ bio: "The bio", interests: [], pof_key: SecureRandom.hex, username: SecureRandom.hex }.merge(params))
  end

  def self.create(params = {})
    build.save
  end

  def self.from_test_fixture(fname)
    content = File.read(File.join(ROOT_DIR, 'spec', 'test_files', fname))
    parser = ProfilePageParser.new(page_content: content)
    Profile.create(
      username: parser.username,
      pof_key: parser.pof_key,
      page_content: content
    )
  end

  def self.build_messagable(params = {})
    _build({ bio: "The bio", interests: ['biking'] }.merge(params))
  end

  def self.create_messagable(params = {})
    build_messagable(params).save
  end

private
  def self._build(params)
    p = Profile.new(params)
    p.skip_parsing_page_content
    p
  end
end
