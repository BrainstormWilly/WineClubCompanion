class Vin65::V3::CreditCardService

  def initialize(username, password)
    @username = username
    @password = password
    @client = Savon.client(wsdl: "https://webservices.vin65.com/V300/CreditCardServiceX.cfc?wsdl")
  end

  def operations
    return @client.operations
  end

  def search_credit_cards

  end

end
