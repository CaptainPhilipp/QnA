# http://freelancing-gods.com/thinking-sphinx/testing.html#acceptance
module SphinxMacros
  def index
    ThinkingSphinx::Test.index
    # Wait for Sphinx to finish loading in the new index files.
    sleep 0.25 until index_finished?
  end

  def index_finished?
    Dir[indices_tmp_files].empty?
  end

  private

  def indices_tmp_files
    Rails.root.join(indices_location, '*.{new,tmp}*')
  end

  def indices_location
    ThinkingSphinx::Test.config.indices_location
  end
end
