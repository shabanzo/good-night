# frozen_string_literal: true

module ResultHandler
  private def handle_success(payload)
    OpenStruct.new(
      success?: true,
      failure?: false,
      success:  payload
    )
  end

  private def handle_failure(payload)
    OpenStruct.new(
      success?: false,
      failure?: true,
      failure:  payload
    )
  end
end
