import stripe

from firebase_functions import https_fn
from firebase_admin import initialize_app
from firebase_functions.params import SecretParam;

STRIPE_SECRET_KEY = 'sk_test_51OFdVPF4ZPi532M0ew91YHEf71YokmwTUlJlXDJHs8hxqXhgagk3iGYxXUJz9V9MBpr290eC6lrEBwiwMycMgj7B00yuuWb22S'
app = initialize_app()

@https_fn.on_request()
def stripe_pay_endpoint_method_id(req: https_fn.Request) -> https_fn.Response:
    print(req.method, req.get_json());

    if req.method != "POST":
        return https_fn.response(status=403, response="Forbidden")
    
    data = req.get_json()
    payment_method_id = data.get('paymentMethodId')
    items = data.get('items')
    currency = data.get('currency')
    use_stripe_sdk = data.get('useStripeSdk')


    # TODO: Calculate the total price
    # You should always calculate the order total on the server to prevent
    # people from directly manipulating the amount on the client 
    total = _calculate_order_amount(items)

    try:
        if payment_method_id:
            params = {
                'payment_method': payment_method_id,
                'amount': total,
                'currency': currency,
                'confirm': True,
                'use_stripe_sdk': use_stripe_sdk,
                'automatic_payment_methods': {
                    'enabled': True, 
                    'allow_redirects': 'never',
                }
            }
            intent = stripe.PaymentIntent.create(api_key=STRIPE_SECRET_KEY, **params)
            return _generate_response(intent)
        else:
            return https_fn.Response(status=400, response="Bad request")
        
    except Exception as e:
        return https_fn.Response(status=500, response=str(e))
    

def _generate_response(intent):
    if intent.status == 'requires_action':
        return {
            'clientSecret': intent.client_secret,
            'requiresAction': True,
            'status': intent.status
        }
    elif intent.status == 'requires_payment_method':
        return {"error": "Your card was denied, please proviedr a new payment method"}
    elif intent.status == "succeeded":
        print("💰 Payment received!")
        return {"clientSecret": intent.client_secret, "status": intent.status}
    else:
        return {"error": "Failed"}
    

def _calculate_order_amount(items):
    total = 0
    for item in items:
        total += item['price'] * item['quantity']
    return int (total * 100)