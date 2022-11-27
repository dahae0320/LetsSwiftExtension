// 2. pop.js 에서 보낸 메세지 수신(onMessage)이 확인되면
// 3. background.js로 메세지 송신(sendMessage)
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    browser.runtime.sendMessage({ greeting: "pass", location : window.location, body : document.documentElement.innerHTML }).then((response) => {
        console.log("Receive from background response: ", response);
    });
    sendResponse({"passed": true});
});
