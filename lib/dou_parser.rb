require 'httparty'
require 'nokogiri'
require 'byebug'

class DouParser
  def initialize
    url = 'https://jobs.dou.ua/first-job/'
    html = HTTParty.get(url)
    @page = Nokogiri::HTML(html.body)
  end

  def result(language)
    res = ""
    events_include_lang = parsed_events.keys.select { |el| el.downcase.match(/\b#{language.downcase}\b/) }
    vacancies_include_lang = parsed_vacancies.keys.select { |el| el.downcase.match(/\b#{language.downcase}\b/)}
    if events_include_lang.empty? && vacancies_include_lang.empty?
      res << 'Sorry, there are no events or vacancies for this language/technology for now :('
      res
    else
      res << "Hooray! There are some events or vacancies for this language/technology.\n" \
          << "\n\n" \
          << events_result(events_include_lang) \
          << "\n\n" \
          << vacancies_result(vacancies_include_lang)
      res
    end
  end

  private

  def parsed_events
    events = @page.at('.first-job-events')
    events_names = events.css('.b-postcard .title a').map { |el| el.children[1].values.last }
    events_links = events.css('.b-postcard .title a').map { |el| el.values.first }
    events_hash = events_names.zip(events_links).to_h
  end

  def parsed_vacancies
    vacancies = @page.at('.first-job-vacancies')
    vacancies_names = vacancies.css('.l-vacancy .title .vt').map { |el| el.children.text }
    vacancies_links = vacancies.css('.l-vacancy .title .vt').map { |el| el['href'] }
    vacancies_hash = vacancies_names.zip(vacancies_links).to_h
  end

  def events_result(events)
    res = ""
    res << "<b>Events</b>: #{events.size}\n"
    parsed_events.each do |key, value|
      res << "&#128165; #{key}: #{value}\n" if events.include?(key)
    end
    res
  end

  def vacancies_result(vacancies)
    res = ""
    res << "<b>Vacancies</b>: #{vacancies.size}\n"
    parsed_vacancies.each do |key, value|
      res << "&#128165; #{key}: #{value}\n" if vacancies.include?(key)
    end
    res
  end
end
