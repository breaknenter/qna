require 'sphinx_helper'

feature 'Search with Sphinx', sphinx: true do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, title: 'Question title', author: author) }
  given!(:answer) { create(:answer, text: 'Answer text', question: question, author: author) }
  given!(:comment) { create(:comment, text: 'Comment text', commentable: question, author: author) }

  background do
    ThinkingSphinx::Test.index

    visit root_path
  end

  scenario 'with no matches' do
    search(query: 'No matches')

    within('.results') do
      expect(page).to have_content 'Ничего не найдено :('
    end
  end

  scenario 'by question title everywhere' do
    search(query: question.title)

    within('.results') do
      expect(page).to have_content question.title
    end
  end

  scenario 'by questions' do
    search(query: question.title, by: 'question')

    within('.results') do
      expect(page).to have_content question.title
    end
  end

  scenario 'by answers' do
    search(query: answer.text, by: 'answer')

    within('.results') do
      expect(page).to have_content answer.text
    end
  end

  scenario 'by comments' do
    search(query: comment.text, by: 'comment')

    within('.results') do
      expect(page).to have_content comment.text
    end
  end

  scenario 'by user email' do
    search(query: author.email, by: 'user')

    within('.results') do
      expect(page).to have_content author.email
    end
  end

  private

  def search(query: '', by: 'all')
    fill_in :search_query, with: query
    select by, from: :search_by
    click_on 'Искать'
  end
end
