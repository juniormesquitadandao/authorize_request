class ActionAuthorizer::Base

  attr_reader :authenticated

  def initialize(authenticated, action, params = {})
    @authenticated = authenticated
    @action = action
    @params = params
  end

  def unauthorized?
    @result = send(@action)

    if !@result.kind_of?(Hash) || @params.empty?
      @result.blank?
    else
      unauthorized_params.any?
    end
  end

  private

  def unauthorized_params
    @unauthorized_params = @result.select do |name, values|
      param_value = @params[name].to_s
      param_value.present? && values.map!{|v| v.to_s}.exclude?(param_value)
    end
    @unauthorized_params
  end

end