module TestFilesHelper
  def test_file_path(test_file)
    Rails.root.join("spec", "test_files", test_file)
  end

  def test_file_content(test_file)
    File.read(test_file_path(test_file))
  end
end
