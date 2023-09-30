require 'MailchimpTransactional'

class HomeController < ApplicationController
  MANDRILL_API_KEY = ENV["MANDRILL_API_KEY"]

  def index
    # This is where all the logic will live for the webpage, home/index
  end

  def about
  end

  def submit_form
    first_name = params[:first_name]
    @email = params[:email]
    Rails.logger.info(@email)
    puts "Hello, #{MANDRILL_API_KEY}!"

    client = MailchimpTransactional::Client.new(MANDRILL_API_KEY)
    message_content = {
      from_email: "hello@jackieho.xyz",
      from_name: first_name,
      subject: "Your free soap is on the way!",
      to: [
        {
          email: "hello@jackieho.xyz",
          type: "to"
        }
      ],
      global_merge_vars: [
        { name: 'FIRST_NAME', content: first_name }
      ],
    }

    message = {
      message: message_content,
      # to: [
      #   {
      #     email: "jackieh.be@gmail.com",
      #     type: "to"
      #   }
      # ]
    }
    
    begin
      response = client.messages.send_template(
      {
        'template_name' => 'saola_demo',
        'template_content' => [{}],
        'message' => message_content
      }
    )
      Rails.logger.info(response)
      p response
    rescue MailchimpTransactional::ApiError => e
      puts "Error: #{e}"
    end

    # message = {
    #   subject: 'Your free soap is arriving soon!',
    #   from_name: 'SAOLA Soaps',
    #   to: [{ email: @email, name: @first_name }],
    #   global_merge_vars: [
    #     { name: 'FIRST_NAME', content: @first_name }
    #   ],
    #   template_name: 'saola_demo',
    #   template_content: [],
    #   merge_vars: [
    #     {
    #       rcpt: @email,
    #       vars: [
    #         { name: 'MERGE_VAR_NAME', content: 'MERGE_VAR_CONTENT' }
    #       ]
    #     }
    #   ]
    # }

    # mandrill.messages.send_template('saola_demo', [], message)

    redirect_to root_path, notice: 'Form submitted successfully!'
  end
end
