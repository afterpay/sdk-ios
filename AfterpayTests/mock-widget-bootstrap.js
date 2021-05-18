document.getElementById("afterpay-widget-container").innerHTML = "Mock bootstrap loaded…"

function createAfterpayWidget(token, amount, locale, style) {
  document.getElementById("afterpay-widget-container").innerHTML = JSON.stringify({
    "token": token,
    "amount": amount,
    "locale": locale,
    "style": style
  });
}

function updateAmount(amount) {
  document.getElementById("afterpay-widget-container").innerHTML =
    "Update called with " + JSON.stringify(amount);
}
