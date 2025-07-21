import web_webview from '@ohos.web.webview';
import { systemDateTime } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
@Entry
@Component

struct Index {
  // 网页视图控制器
  private controller: web_webview.WebviewController = new web_webview.WebviewController();
  // 主页URL（可在此处设置默认主页）
  private homeUrl: string = 'https://sraxc.github.io/2.html';
  // 当前URL
  @State currentUrl: string = this.homeUrl;
  // 历史记录栈
  @State historyStack: Array<string> = [this.homeUrl];
  // 当前历史记录索引
  @State currentIndex: number = 0;
  //退出计时器
  @State currentTime: number = 0;


  onBackPress(): boolean | void {
    if (this.currentIndex > 0) {
      this.currentIndex--;
      this.currentUrl = this.historyStack[this.currentIndex];
      this.controller.loadUrl(this.currentUrl);
      return true
    } else {
      if (this.currentTime == 0) {
        this.currentTime = systemDateTime.getUptime(1);
        setTimeout((() => {
          this.currentTime = 0
        }), 2000);
        promptAction.showToast({
          message: "再按一次退出",
          duration: 2000
        })
        return true
      } else {
        if (systemDateTime.getUptime(1) - this.currentTime <= 2000) {
          this.currentTime = 0;
          return false
        } else {
          this.currentTime = 0;
          return true
        }
      }
    }
  }


  build() {
    Column() {


      // 导航栏
      // Row() {
      // 返回上一页按钮
      // Button('◀')
      // .enabled(this.currentIndex > 0)
      // .visibility(Visibility.None)
      // .defaultFocus(true)
      // .onKeyPreIme((event) => {
      //   if (event.keyCode === KeyCode.KEYCODE_BACK){
      //     if (this.currentIndex > 0) {
      //       this.currentIndex--;
      //       this.currentUrl = this.historyStack[this.currentIndex];
      //       this.controller.loadUrl(this.currentUrl);
      //       return true
      //     }else{
      //       return false
      //     }
      //   }else{return false}
      // })
      // .onClick(() => {
      // if (this.currentIndex > 0) {
      //   this.currentIndex--;
      //   this.currentUrl = this.historyStack[this.currentIndex];
      //   this.controller.loadUrl(this.currentUrl);
      // }
      //   this.detectScrollPosition()
      // })

      // 返回主页按钮
      // Button('主页')
      //   .onClick(() => {
      //     this.currentUrl = this.homeUrl;
      //     this.controller.loadUrl(this.currentUrl);
      //
      //     // 如果主页不在历史记录中，添加到历史记录
      //     if (this.historyStack[this.currentIndex] !== this.homeUrl) {
      //       this.historyStack = this.historyStack.slice(0, this.currentIndex + 1);
      //       this.historyStack.push(this.homeUrl);
      //       this.currentIndex++;
      //     }
      //   })

      // 刷新按钮
      // Button('刷新')
      //   .onClick(() => {
      //     this.controller.loadUrl(this.currentUrl);
      //   })

      // 地址栏（预留）
      //   Text(this.currentUrl)
      //     .fontSize(14)
      //     .margin({ left: 5, right: 5 })
      //     .width('*')
      // }
      // .width('100%')
      // .padding(10)

      Web({ src: this.currentUrl, controller: this.controller })
        .width('100%')
        .height('100%')
        .margin({ top: 0 })
        .onPageEnd((event: OnPageEndEvent) => {
          // 页面加载完成后更新URL和历史记录
          if (event.url && event.url !== this.currentUrl) {
            // 如果是后退/前进操作，不添加新历史记录
            if (this.historyStack[this.currentIndex] === event.url) {
              return;
            }

            // 清除当前位置之后的历史记录并添加新记录
            this.historyStack = this.historyStack.slice(0, this.currentIndex + 1);
            this.historyStack.push(event.url);
            this.currentIndex++;
            this.currentUrl = event.url;
          }
        })
      // 功能区（预留）
      // Row() {
      //   Button('<')
      //     .enabled(this.currentIndex > 0)
      //     .defaultFocus(true)
      //     .onClick(() => {
      //       if (this.currentIndex > 0) {
      //         this.currentIndex--;
      //         this.currentUrl = this.historyStack[this.currentIndex];
      //         this.controller.loadUrl(this.currentUrl);
      //       }
      //     })
      // }
      // .position({left:5,bottom:0})
    }
    .width('100%')
    .height('100%')
  }
}

