require 'spec_helper'
require 'elasticsearch'

describe TaskHelpers do
  describe TaskHelpers::ElasticsearchHelper do

    context("#rebuild_indices") do
      include_context 'search_enabled'

      it "builds new index with content" do
        TaskHelpers::ElasticsearchHelper.delete_indices
        TaskHelpers::ElasticsearchHelper.rebuild_indices
        create(:comment_thread, body: 'the best test body', course_id: 'test_course_id')
        TaskHelpers::ElasticsearchHelper.refresh_indices
        Elasticsearch::Model.client.search(
            index: TaskHelpers::ElasticsearchHelper::INDEX_NAMES
        )['hits']['total']['value'].should be > 0
      end

    end

    context("#validate_index") do
      subject { TaskHelpers::ElasticsearchHelper.validate_indices}

      it "validates the 'content' alias exists with proper mappings" do
        subject
      end

      it "fails if one of the index doesn't exist" do
        Elasticsearch::Model.client.indices.delete(index: Comment.index_name)
        expect{subject}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
      end

    end

  end
end
