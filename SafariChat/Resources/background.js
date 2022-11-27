// 4. content.js에서 메세지 수신(onMessage)이 확인되면
// 5. Safari Extension(SafariChat)에게 메세지 송신(sendNativeMessage)

// Safari Extension으로 메세지를 보낼 수 있는 곳은 background밖에 없다.
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    sendResponse({ farewell: "passed" });
    browser.runtime.sendNativeMessage('com.dadahae.DefaultMacApp.SafariChat', {
        "body" : request.body,
        "location" : request.location.href});
});

