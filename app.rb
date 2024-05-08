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
  
  # Define the GET endpoint to retrieve data for a specific vendorProject
  # Try adding Apache and Accellion as parameters
get '/api/get-vendor/:vendorProject' do
    vendor_project = params['vendorProject']
    
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
    
    # Filter data based on the vendorProject
    vendor_data = known_vuln['vulnerabilities'].select { |vuln| vuln['vendorProject'] == vendor_project }
    
    # Count the number of found vulnerabilities
    count = vendor_data.count
    
    # Prepend the response with "VendorKEV: (count of found vulnerabilities)"
    response_data = { 
      "VendorKEV" => "Found #{count} vulnerabilities",
      "vendor_data" => vendor_data 
    }
    
    # Return data as JSON response
    content_type :json
    response_data.to_json
  end
  
  # Define the GET endpoint to retrieve a list of vendors
get '/api/get-vendor-list' do
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
    
    # Extract the list of unique vendor names
    vendor_names = known_vuln['vulnerabilities'].map { |vuln| vuln['vendorProject'] }.uniq
    
    # Count the number of unique vendors
    vendor_count = vendor_names.count
    
    # Return data as JSON response
    content_type :json
    { 
      "VendorCount" => vendor_count,
      "VendorList" => vendor_names 
    }.to_json
  end
  