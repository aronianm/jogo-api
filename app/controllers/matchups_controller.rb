class MatchupsController < ApplicationController
  before_action :set_matchup, only: %i[ show update destroy ]

  # GET /matchups
  def index
    @matchups = Matchup.includes(:userTwo, :userOne).where(:league_id => params[:league_id]).as_json(
      include: {
        userOne: { only: [:id, :fname, :lname] },
        userTwo: { only: [:id, :fname, :lname] }
      }
    )

    @matchups.each do |m|
      if m['userOne']['id'] == current_user.id
        m['currentUser'] = m['userOne']['id']
      elsif m['userTwo']['id'] == current_user.id
        m['currentUser'] = m['userTwo']['id']
      else
        m['currentUser'] = 0
      end
        m['userOneScore'] = (m['userOneDailyScore'] + m['userOneTotalScore']).round(2)
        m['userTwoScore'] = (m['userTwoDailyScore'] + m['userTwoTotalScore']).round(2)
    end
    @matchups = @matchups.sort_by{|t| t['currentUser'] == current_user.id ? 0 : 1}
    render :json => @matchups

  end

  def challenges
    @matchups = Matchup.find_users_invites(current_user.id).as_json(
      include: {
        userOne: { only: [:id, :fname, :lname] },
        userTwo: { only: [:id, :fname, :lname] }
      }
    )
    @matchups.each {|m| m['currentUser'] = current_user.id}

    render json: @matchups
  end

    def update_scores
        # first we get the score

        score = params['score']
        # now we get today since health kit is only stored 
        # for each day
        today = Date.today + 1.day 
        @league = League.find(params[:league_id])
        # the we grab the matchup
        @matchup = Matchup.find(params[:id])
        # then we grab the active season 
        # there should only be one 
        # other wise the matchup is retired or the user has not accepted it yet
        if @matchup.isActive
            # then we check if the current user equals user 1
            # becuase they are two users on each matchup
            if @matchup.userOne.id == current_user.id && @matchup.userOneScoreUpdated <= today
                # if last time the user updated his score
                # then the score will be updated.
                # now we check the daily score
                # and if they don't equal we make the 
                # userDailyOneScore = score
                if @matchup.userOneScoreUpdated < today
                  # update score to to the total and set the dailyscore to 0
                  @matchup.userOneTotalScore += @matchup.userOneDailyScore
                  @matchup.userOneDailyScore = 0
                  # thene we reset everything so that this total
                  # score is not updated again until the next day
                  @matchup.userOneScoreUpdated = today 
                end
                if @matchup.userOneDailyScore != score
                    @matchup.userOneDailyScore = score
                end
                @matchup.save
            elsif @matchup.userTwo.id == current_user.id  && @matchup.userTwoScoreUpdated <= today
                # now we do the same thing for user2
                if @matchup.userTwoScoreUpdated < today
                  @matchup.userTwoTotalScore += @matchup.userTwoDailyScore
                  @matchup.userTwoDailyScore = 0
                  @matchup.userTwoScoreUpdated = today
                end 
                if @matchup.userTwoDailyScore != score
                  @matchup.userTwoDailyScore = score
                  
                end
                @matchup.save
            end
            render :json => @matchup
        end

        @matchup = Matchup.includes(:userTwo, :userOne).find(@matchup.id).as_json(
          include: {
            seasons: {},
            userOne: { only: [:id, :fname, :lname] },
            userTwo: { only: [:id, :fname, :lname] }
          }
        )

        if @matchup['userOne']['id'] == current_user.id
          @matchup['currentUser'] = @matchup['userOne']['id']
          @matchup['currentUserScore'] = (@matchup['userOneDailyScore'] + @matchup['userOneTotalScore']).round(2)
          @matchup['opponentScore'] = (@matchup['userTwoDailyScore'] + @matchup['userTwoTotalScore']).round(2)
        else
          @matchup['currentUser'] = @matchup['userTwo']['id']
          @matchup['opponentScore'] = (@matchup['userOneDailyScore'] + @matchup['userOneTotalScore']).round(2)
          @matchup['currentUserScore'] = (@matchup['userTwoDailyScore'] + @matchup['userTwoTotalScore']).round(2)
        end
        render :json => @matchup
    end

  # GET /matchups/1
  def show
    @matchup.viewing_user = current_user.id
    render json: @matchup.as_json(
      include: {
        seasons: {
          include: :season_matchups
        }
      }
    )
    
  end

  # POST /matchups
  def create
    @matchup = Matchup.new()
    user = User.find_by_phone params[:phone_number]
    @matchup.userOne = user
    @matchup.userTwo = current_user
    @matchup.createdBy = current_user.id
    if @matchup.save
      render json: @matchup, status: :created, location: @matchup
    else
      render json: @matchup.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matchups/1
  def update

    if @matchup.update(matchup_params)
      render json: @matchup
    else
      render json: @matchup.errors, status: :unprocessable_entity
    end
  end

  # DELETE /matchups/1
  def destroy
    @matchup.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matchup
      @matchup = Matchup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def matchup_params
      params.require(:matchup).permit(:userAccepted)
    end
end
