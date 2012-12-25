module OdnoklassnikiAPI
  module Error

    API_ERROR_CODES = {
        "1" => "UnknownError",
        "2" => "ServiceError",
        "3" => "MethodError",
        "4" => "RequestError",
        "7" => "ActionBlockedError",
        "8" => "FloodBlockedError",
        "9" => "IpBlockedError",
        "10" => "PermissionDeniedError",
        "11" => "LimitReachedError",
        "100" => "ParamError",
        "101" => "ParamApiKeyError",
        "102" => "ParamSessionExpiredError",
        "103" => "ParamSessionKeyError",
        "104" => "ParamSignatureError",
        "105" => "ParamReSignatureError",
        "110" => "ParamUserIdError",
        "120" => "ParamAlbumIdError",
        "130" => "ParamWidgetError",
        "140" => "ParamMessageIdError",
        "200" => "ParamPermissionError",
        "210" => "ParamApplicationDisabledError",
        "300" => "NotFoundError",
        "453" => "SessionRequiredError",
        "455" => "FriendRestrictionError",
        "900" => "NoSuchAppError",
        "9999" => "SystemError",
        "1001" => "CallbackInvalidPaymentError",
        "1002" => "PaymentIsRequiredPaymentError"
    }

    class ApiError < StandardError

      def self.raise_by_code(code=nil)
        raise get_by_code(code)
      end

      def self.get_by_code(code=nil)
        if API_ERROR_CODES[code].nil?
          UnknownApiError
        else
          OdnoklassnikiAPI::Error.const_get(API_ERROR_CODES[code])
        end
      end
    end

    class UnknownError < ApiError; end # 1
    class ServiceError < ApiError; end # 2
    class MethodError < ApiError; end # 3
    class RequestError < ApiError; end # 4
    class ActionBlockedError < ApiError; end # 7
    class FloodBlockedError < ApiError; end # 8
    class IpBlockedError < ApiError; end # 9
    class PermissionDeniedError < ApiError; end # 10
    class LimitReachedError < ApiError; end # 11
    class ParamError < ApiError; end # 100
    class ParamApiKeyError < ApiError; end # 101
    class ParamSessionExpiredError < ApiError; end # 102
    class ParamSessionKeyError < ApiError; end # 103
    class ParamSignatureError < ApiError; end # 104
    class ParamReSignatureError < ApiError; end # 105
    class ParamUserIdError < ApiError; end #  110
    class TParamAlbumIdError < ApiError; end # 120
    class ParamWidgetError < ApiError; end # 130
    class ParamMessageIdError < ApiError; end # 140
    class ParamPermissionError < ApiError; end # 200
    class ParamApplicationDisabledError < ApiError; end # 210
    class NotFoundError < ApiError; end # 300
    class SessionRequiredError < ApiError; end # 453
    class FriendRestrictionError < ApiError; end # 455
    class NoSuchAppError < ApiError; end # 900
    class SystemError < ApiError; end # 9999
    class CallbackInvalidPaymentError < ApiError; end # 1001
    class PaymentIsRequiredPaymentError < ApiError; end # 1002
    class UnknownApiError < ApiError; end # unknown codes

    class TimeoutError < ApiError; end

    class InvalidJsonResponseError < StandardError; end
    class InvalidResponseStatusError < StandardError; end
    class ParsingError < StandardError; end
    class WrongStatusError < StandardError; end

  end
end
