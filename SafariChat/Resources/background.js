//browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
//    console.log("Received request: ", request);
//
//    if (request.greeting === "hello") {
//        sendResponse({ farewell: "goodbye" });
//
//    } else if (request.greeting == "pass") {
//        sendResponse({ farewell: "notbye" });
//
//    } else if (request.greeting == "content") {
//        sendResponse({ farewell: "content"});
//    }
//    // Native app 에 메세지 보냄
//    browser.runtime.sendNativeMessage('com.dadahae.DefaultMacApp.SafariChat', {
//        "body" : request.body,
//        "location" : request.location.href});
//});


// 4. content.js에서 메세지 수신(onMessage)이 확인되면
// 5. Safari Extension(SafariChat)에게 메세지 송신(sendNativeMessage)
// Safari Extension으로 메세지를 보낼 수 있는 곳은 background밖에 없다.
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    sendResponse({ farewell: "passed" });
    browser.runtime.sendNativeMessage('com.dadahae.DefaultMacApp.SafariChat', {
        "body" : request.body,
        "location" : request.location.href});
});

