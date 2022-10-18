class SetDestinationService
  attr_reader :res

  def initialize(id_token)
    @id_token = id_token
  end

  def call
    channel_id = ENV['CHANNEL_ID']
    @res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'), { 'id_token' => @id_token, 'client_id' => channel_id })
  end

  def res_body
    @res.body
  end
end
