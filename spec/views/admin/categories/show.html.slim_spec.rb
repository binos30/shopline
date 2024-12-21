# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/categories/show", type: :view do
  let!(:category) { create :category }

  before do
    assign(:category, category)

    # Turns off the verifying of partial doubles for the duration of the block,
    # this is useful in situations where methods are defined at run time and you wish
    # to define stubs for them but not turn off partial doubles for the entire run suite.
    without_partial_double_verification { allow(view).to receive(:category).and_return(category) }
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/Description/)
  end
end
