PASSWORD = 'init'
PASSWORD_DIGEST = BCrypt::Password.create(PASSWORD).to_s # '$2a$10$Cz/9k8UI10wr80j6hsM0K.sWS9VIt.o1WZvaOVH6y/XvovvpL1qzq' 

# - - - - LOGIN - - - -
When(/^the user is on the homepage$/) do
  visit('/')
end

When(/(?:opens|has opened) the (.+) page$/) do |page|
  visit "/#{page}"
  step "should be redirected to the #{page} page"
end

When(/^the user logs in with (.*) and (.*)$/) do |user_name, password|
  fill_in('session_user_name', with: user_name)
  fill_in('session_password', with: password)

  find('[name=commit]').click
end

Then(/^the field should display the error message$/) do |table|
  error_count = 0
  table.rows_hash.each do |field_class, message|
    error_message_css = "div.#{field_class} div.uk-text-danger"
    if message.blank?
      assert has_no_css?(error_message_css)
    else
      error_count += 1
      assert_equal message, find(error_message_css).text
    end
  end
  assert_equal error_count, page.all('div.uk-text-danger').count
end

Then(/^the user name should only be a link to (.*) for students$/) do |link|
  ['full_name_offcanvas', 'full_name'].each do |id|
    if link.blank?
      assert has_no_css?("##{id} a")
    else
      assert has_css?("##{id} a[href$='#{link}']")
    end
  end
end

# - - - - SHARED - - - -
Given(/^the following (\w+)$/) do |model_name, table|
  values = rows_hash_to_nested_hash(table.rows_hash)
  values[:password_digest] = PASSWORD_DIGEST if ['Person', 'Student'].include?(model_name)
  @model = instantiate_object(model_name, values)
  assert_equal true, @model.save!
end

Given(/^the following items of type (\w+)$/) do |model_name, table|
  table.hashes.each do |item|
    values = rows_hash_to_nested_hash(item)
    values[:password_digest] = PASSWORD_DIGEST if ['Person', 'Student'].include?(model_name)
    @model = instantiate_object(model_name, values)
    assert_equal true, @model.save!
  end
end

Given(/^the (?:user|administrator) is logged in$/) do
  request_headers['HTTP_AUTHORIZATION'] = "Token #{@model.token}"
end

Then(/^the response should contain$/) do |table|
  response = table.rows_hash

  assert_equal response['status_message'], Rack::Utils::HTTP_STATUS_CODES[@response.status]

  response_body = JSON.parse(@response.body)
  assert_equal true, response_body.key?(response['response_body_element'])
end

Then(/^the response array should contain the following ids$/) do |table|
  table.rows_hash.each do |keys, value|
    if value.present?
      response = JSON.parse(@response.body)[0]
      keys.split(".").each {|key| response = response.fetch(key)}

      assert_equal value, response.to_s
    end
  end
end

Then(/^the response array should contain the following error: (.*)$/) do |error_message|
  if error_message.present?
    response = JSON.parse(@response.body)[0]

    assert_equal error_message, response['full_messages'][0]
  end
end

When(/enters the following data$/) do |table|
  table.rows_hash.each do |key, value|
    fill_in key, with: value
  end
end

# - - - - ENTERPRISE - - - -
When(/^the user wants to create the following enterprise$/) do |table|
  enterprise = rows_hash_to_nested_hash(table.rows_hash)

  @response = post '/enterprises.json',
                   {enterprise: enterprise},
                   request_headers
end

Then(/should see (\d+) enterprises?$/) do |enterprises_count|
  assert_equal enterprises_count.to_i, page.all("div[id^='enterprise-'] h3").count
end

When(/searches for enterprises with name (.*) and country (.*)$/) do |name, country|
  fill_in id: 'name', with: name if name.present?
  select country, from: :country_id if country.present?
end

Then(/should see the (.+)s with ids (.*)$/) do |type, ids|
  ids = ids.split(',')
  assert_equal ids.length, page.all("div[id^='#{type}-'] h3").count
  ids.each do |id|
    assert has_css?("##{type}-#{id} h3")
  end
end

# - - - - STUDENT - - - -
Given(/with id (\d+) is logged in$/) do |id|
  person = Person.find(id.to_i)
  password = PASSWORD
  steps %Q{
    Given the user is on the homepage
    And the user logs in with #{person.login} and #{password}
  }
end

Then(/should see (\d+) students$/) do |students_count|
  assert_equal students_count.to_i, page.all("div[id^='student-']").count
end

Then(/should see (\d+) student profile links?$/) do |links_count|
  assert_equal links_count.to_i, page.all("div[id^='student-'] h3 a").count
end

When(/opens the (\w+) with id (\d+)$/) do |type, id|
  visit "/#{type}s/#{id}"
end

Then(/should see the profile page of student with id (\d+)$/) do |id|
  step "should see the students/#{id} page"
end

Then(/should (?:see|be redirected to) the (.+) page$/) do |page|
  assert current_url.end_with? page
end

And(/should see the (.+) message "(.*)"$/) do |type, message|
  message_css = "div.uk-alert-#{type == 'error' ? 'danger' : type}"
  if message.blank?
    assert has_no_css?(message_css)
  else
    assert_equal message, find(message_css).text
  end
end

# - - - - IMPORT - - - -
When(/^the user wants to create the following internship/) do |table|
  # internship = rows_hash_to_nested_hash(table.rows_hash)
  spreadsheet = table.rows_hash.values.join("\t")

  @response = post '/import.json',
                   {import: {spreadsheet: spreadsheet}},
                   request_headers
end

Then(/^the user should be redirected to the homepage$/) do
  step 'should be redirected to the /en page'
end

When(/(?:clicks|has clicked) on (.+)$/) do |text|
  begin
    click_on text
  rescue Capybara::Ambiguous
    click_on id: text
  end
end

When(/checks the following checkboxes$/) do |table|
  table.rows_hash.each do |key, value|
    check key if value.present?
  end
end

When(/selects the following options$/) do |table|
  table.rows_hash.each do |key, value|
    select value, from: key if value.present?
  end
end

Then(/should see the following information$/) do |table|
  table.rows_hash.each do |key, value|
    css = "##{key}"
    if value.blank?
      assert has_no_css?(css)
    else
      assert_equal value, find(css).text
    end
  end
end

When(/searches and selects the following data$/) do |table|
  # table is a table.hashes.keys # => [:enterprise_name, :<enterprise_name>]
  pending
end

And(/chooses the following options$/) do |table|
  # table is a table.hashes.keys # => [:internship_lang_id, :<lang>]
  pending
end