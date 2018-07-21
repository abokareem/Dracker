import UIKit
import Alamofire
import AWSS3

//Get current user's transaction data
func fetch_data(user_id: String, completion: @escaping () -> Void) {
    make_api_call(parameters: [:], api_endpoint: nil, method: .get, custom_endpoint: Endpoints.base + "/users/\(user_id)") { (data) in
        if data.isFailure {
            completion()
            return
        }
        let result = data.value as! [String: Any]
        let settled_string = (result["settled"] as? String)?.data(using: .utf8)!
        let unsettled_string = (result["unsettled"] as? String)?.data(using: .utf8)!
        if settled_string != nil
        {
            //Decode settled array
            do {
                settled_transactions = try JSONDecoder().decode([Settled].self, from: settled_string!)
            } catch {
                //Should never happen
            }
        }
        if unsettled_string != nil {
            //Decode unsettled array
            do {
                unsettled_transactions = try JSONDecoder().decode([Unsettled].self, from: unsettled_string!)
            } catch {
                //Should never happen
            }
        }

        credit = result["credit"] as! Double
        debit = result["debit"] as! Double
        completion()
    }
}

//Get current user's Friends_data
func fetch_friends(user_id: String, completion: @escaping () -> Void) {
    make_api_call(parameters: [:], api_endpoint: nil, method: .get, custom_endpoint: Endpoints.friends + "/\(user_id)") { (data) in
        if data.isFailure {
            completion()
            return
        }
        friends = []
        let result = data.value as! [String: Any]
        for (uid,value) in result {
            let data_string = (value as? String)?.data(using: .utf8)!
            //Decode settled array
            do {
                var friend = try JSONDecoder().decode(Friends.self, from: data_string!)
                friend.uid = uid
                friends.append(friend)
            } catch {
                //Should never happen
            }
            
        }
        completion()
    }
}

//Get user's data
func get_user_data(phone: String, completion: @escaping ((Result<Any>) -> Void)) {
    make_api_call(parameters: ["phone": phone], api_endpoint: Endpoints.user_data, method: .get, custom_endpoint: nil, completion: completion)
}

func post_delete_transaction(parameters: [String: String], completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: parameters, api_endpoint: Endpoints.delete_transaction, method: .get, custom_endpoint: nil, completion: completion)
}

func post_settle_transaction(parameters: [String: String], completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: parameters, api_endpoint: Endpoints.settle_transaction, method: .get, custom_endpoint: nil, completion: completion)
}

func update_email(parameters: [String: String], completion: @escaping ((Result<Any>) -> Void)) {
    make_api_call(parameters: parameters, api_endpoint: Endpoints.update_email, method: .put, custom_endpoint: nil, completion: completion)
}

func put_transaction(parameters: [String: String], completion: @escaping ((Result<Any>) -> Void))
{
    make_api_call(parameters: parameters, api_endpoint: Endpoints.add_transaction, method: .put, custom_endpoint: nil, completion: completion)
}

//Get list of users
func get_users(completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: [:], api_endpoint: Endpoints.users_list, method: .get, custom_endpoint: nil, completion: completion)
}

func create_user(phone: String, password: String, email: String, name: String, completion: ((Result<Any>) -> Void)? = nil) {
    let parameters = ["phone" : phone, "password" : password, "email" : email, "name" : name]
    make_api_call(parameters: parameters, api_endpoint: Endpoints.add_user, method: .put, custom_endpoint: nil, completion: completion)
}

func get_transaction(parameter: [String: String], completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: parameter, api_endpoint: Endpoints.get_transaction, method: .get, custom_endpoint: nil, completion: completion)
}

fileprivate func make_api_call(parameters: [String: String], api_endpoint: String?, method: HTTPMethod, custom_endpoint: String? = nil, completion: ((Result<Any>) -> Void)? = nil) {
    let headers = ["x-api-key" : Dracker_API_KEY]
    let endpoint = custom_endpoint == nil ? api_endpoint: custom_endpoint
    var encoding: ParameterEncoding = URLEncoding.default
    if method == .put {
        encoding = URLEncoding(destination: .queryString)
    }
    Alamofire.request(endpoint!, method: method, parameters: parameters, encoding:  encoding, headers: headers).responseJSON { response in
        completion?(response.result)
    }
}

//MARK: S3
func upload_to_S3(key: String, data: NSURL, bucket: AWSConstants) {
    let request = AWSS3TransferManagerUploadRequest()
    request?.bucket = bucket.rawValue
    request?.body = data as URL
    request?.key = key
    request?.contentType = "image/jpeg"
    request?.acl = .publicRead
    let client = AWSS3TransferManager.default()
    client.upload(request!)
}
