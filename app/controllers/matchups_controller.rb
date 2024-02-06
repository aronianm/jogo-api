class MatchupsController < ApplicationController
  before_action :set_matchup, only: %i[ show update destroy ]

  # GET /matchups
  def index
    @matchups = Matchup.find_users(current_user.id).as_json(
      include: {
        seasons: {},
        userOne: { only: [:id, :fname, :lname] },
        userTwo: { only: [:id, :fname, :lname] }
      }
    )
    @matchups.each {|m| m['currentUser'] = current_user.id}
    puts @matchups[0]
    render json: @matchups

    
  end

  def challenges
    @matchups = Matchup.find_users_invites(current_user.id).as_json(
      include: {
        seasons: {},
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
        today = Date.today
        # the we grab the matchup
        @matchup = Matchup.find(params[:id])
        # then we grab the active season 
        # there should only be one 
        # other wise the matchup is retired or the user has not accepted it yet
        if @matchup.active?
            @season = @matchup.activeSeason
            # now this current season should have a current matchup
            @season_matchup = @season.max_week_matchup
            # then we check if the current user equals user 1
            # becuase they are two users on each matchup
            if @matchup.userOne.id == current_user.id && @season_matchup.userOneScoreUpdated <= today
                # if last time the user updated his score
                # then the score will be updated.
                # now we check the daily score
                # and if they don't equal we make the 
                # userDailyOneScore = score
                if @season_matchup.userOneDailyScore != score
                    @season_matchup.userOneDailyScore = score
                    @season_matchup.userOneScoreUpdated = today 
                end
                if @season_matchup.userOneScoreUpdated < today
                    # update score to to the total and set the dailyscore to 0
                    @season_matchup.userOneTotalScore += @season_matchup.userOneDailyScore
                    @season_matchup.userOneDailyScore = 0
                end
            elsif @matchup.userTwo.id == current_user.id  && @season_matchup.userTwoScoreUpdated <= today
                if @season_matchup.userTwoDailyScore != score
                    @season_matchup.userTwoDailyScore = score
                    @season_matchup.userTwoScoreUpdated = today 
                end
                # now we do the same thing for user2
                if @season_matchup.userTwoScoreUpdated < today
                    @season_matchup.userTwoTotalScore += @season_matchup.userTwoDailyScore
                    @season_matchup.userTwoDailyScore = 0
                end 
            end

            if @season_matchup.endDate <= today
                if @season_matchup.userOneTotalScore > @season_matchup.userTwoTotalScore
                    @season.userOneWins += 1
                elsif @season_matchup.userOneTotalScore < @season_matchup.userTwoTotalScore
                    @season.userTwoWins += 1
                end
                @season_matchup.active = false
                @season.build_new_week
                @season.save
            end
            @season_matchup.save
            @matchup.save
            render :json => @matchup
            else
            render :json => @matchup
        end
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
