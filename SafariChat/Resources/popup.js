// 1. 사파리에서 확장도구 버튼을 누르면 pop.js 파일 실행
// 정확히는 pop.html이 실행되면서 연결된 pop.css, pop.js 파일 실행

// 현재 브라우저의 탭에서 content.js로 메세지 송신 (sendMessage)
browser.tabs.getCurrent().then((tab) => {
    browser.tabs.sendMessage(tab.id, { greeting: "pass"}).then((response) => {
        console.log("Received response: ", response);
    });
});
