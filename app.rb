require 'bundler'
Bundler.require

# Define a GET endpoint to get all the data
get '/api/getvuln' do
  # Fetch the list of known vulnerabilities from the CISA website
  known_vuln_url = URI("https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json")

  response = Net::HTTP.get_response(known_vuln_url)

  if response.is_a?(Net::HTTPSuccess)
    known_vuln = JSON.parse(response.body)
  else
    # Handle the error case gracefully
    status response.code
    return { error: "Failed to fetch known vulnerabilities: #{response.message}" }.to_json
  end

  # Return the list of known vulnerabilities as a JSON response
  content_type :json
  known_vuln.to_json
end
