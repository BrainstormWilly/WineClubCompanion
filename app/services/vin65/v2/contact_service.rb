class Vin65::V2::ContactService

  def initialize(username, password)
    @username = username
    @password = password
    @client = Savon.client(wsdl: "https://webservices.vin65.com/v201/contactService.cfc?wsdl")
  end

  def operations
    @client.operations
  end

  def get_contact(params)
    params[:username] = @username
    params[:password] = @password
    req = {getContactRequest: params}
    # op = @client.operation(:get_contact)
    # op.build(soap_action: "v201:GetContact", message: req).to_s
    res = @client.call(:get_contact, message: req)
    res.hash
  end

end
