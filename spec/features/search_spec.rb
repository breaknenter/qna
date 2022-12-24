require 'sphinx_helper'

feature 'Search with Sphinx' do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, title: 'Question title', author: author) }
  given!(:answer) { create(:answer, text: 'Answer text', question: question, author: author) }
  given!(:comment) { create(:comment, text: 'Comment text', commentable: question, author: author) }

  background do
    ThinkingSphinx::Test.index

    visit root_path
  end

  scenario 'Search with no matches', sphinx: true do
    search(query: 'No matches')

    ThinkingSphinx::Test.run do
      within('.results') do
        expect(page).to have_content 'Ничего не найдено :('
      end
    end
  end

  scenario 'Search question everywhere', sphinx: true do
    search(query: question.title)

    ThinkingSphinx::Test.run do
      within('.results') do
        expect(page).to have_content question.title
      end
    end
  end

  scenario 'Search by questions', sphinx: true do
    search(query: question.title, by: 'question')

    ThinkingSphinx::Test.run do
      within('.results') do
        expect(page).to have_content question.title
      end
    end
  end

  scenario 'Search by answers', sphinx: true do
    search(query: answer.text, by: 'answer')

    ThinkingSphinx::Test.run do
      within('.results') do
        expect(page).to have_content answer.text
      end
    end
  end

  scenario 'Search by comments', sphinx: true do
    search(query: comment.text, by: 'comment')

    ThinkingSphinx::Test.run do
      within('.results') do
        expect(page).to have_content comment.text
      end
    end
  end

  scenario 'Search by users', sphinx: true do
    search(query: author.email, by: 'user')

    ThinkingSphinx::Test.run do
      within('.results') do
        expect(page).to have_content user.email
      end
    end
  end

  private

  def search(query: '', by: 'all')
    fill_in :search_query, with: query
    select by, from: :search_by
    click_on 'Искать'
  end
end
