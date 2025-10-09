class PollsController < ApplicationController
    before_action :set_poll, only: %i[ show edit update destroy vote]

    def index
        @polls = Poll.all.order(created_at: :desc)
    end

    def show
        @voted = already_voted?
    end

    def new 
        @poll = Poll.new

        2.times { @poll.options.build}
    end

    def create
        @poll = Poll.new(poll_params)

        if @poll.save
            redirect_to @poll, notice: "Poll was successfully created!"

        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit

    end

    def update
        if @poll.update(poll_params)
        redirect_to @poll, notice: "Poll was successfully updated"

        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @poll.destroy
        redirect_to polls_path, notice: "poll deleted successfully"
    end

    def vote

        if already_voted?
            redirect_to @poll, alert: "You have already voted on this poll"
            return
        end

        option = @poll.options.find_by(id: params[:option_id])

        if option.nil?
            redirect_to @poll, alert: 'Please select an option'
            return
        end

        vote = option.votes.build(voter_ip: request.remote_ip)

        if vote.save
            redirect_to @poll, notice: "Thanks for voting"
        else
            redirect_to @poll, alert: vote.errors.full_messages.join(',')
        end
    end

    def set_poll
        @poll = Poll.find(params[:id])
    
    rescue ActiveRecord::RecordNotFound
        redirect_to polls_path, alert: "poll not found"
    end

    def poll_params
        params.require(:poll).permit(
            :title,
            :description,
            options_attributes: [:id, :content, :_destroy]
        )
    end

    def already_voted?
        Vote.joins(:option)
            .where(options: { poll_id: @poll.id})
            .where(voter_ip: request.remote_ip)
            .exists?
    end
     
end
