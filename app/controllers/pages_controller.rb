class PagesController < ApplicationController
  def home
    @products = Product.all.shuffle
  end

  def dashboard

  end

  def redirect
    client = Signet::OAuth2::Client.new({
      client_id: ENV['GOOGLE_API_CLIENT_ID'],
      client_secret: ENV['GOOGLE_API_CLIENT_SECRET'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::AnalyticsV3::AUTH_ANALYTICS_READONLY,
      redirect_uri: url_for(:action => :callback)
    })

    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new({
      client_id: ENV['GOOGLE_API_CLIENT_ID'],
      client_secret: ENV['GOOGLE_API_CLIENT_SECRET'],
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(:action => :callback),
      code: params[:code]
    })

    response = client.fetch_access_token!

    session[:access_token] = response['access_token']

    redirect_to url_for(:action => :analytics)
  end

  def analytics
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])
    client.expires_in = Time.now + 1_000_000
    service = Google::Apis::AnalyticsV3::AnalyticsService.new

    service.authorization = client

    @account_summaries = service.list_account_summaries

    profile_id = "ga:#{service.list_account_summaries.items[0].web_properties[0].profiles[0].id}"

    start_date = 1.month.ago.strftime("%Y-%m-%e").to_s

    end_date = Date.tomorrow.strftime("%Y-%m-%e").to_s

    metrics = 'ga:itemRevenue'

    product_response =  service.get_ga_data(profile_id, start_date, end_date, metrics, {
      dimensions: 'ga:referralPath,ga:campaign,ga:transactionId,ga:productSku,ga:productName'
    })

    # p product_response

    @product_data = product_response.rows
    @product_headers = product_response.column_headers
  end
end
