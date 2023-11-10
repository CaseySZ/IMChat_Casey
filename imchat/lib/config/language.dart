




import 'package:imchat/config/language_han.dart';
import 'package:imchat/config/language_malai.dart';
import 'package:imchat/config/language_riben.dart';
import 'package:imchat/config/language_tai.dart';
import 'package:imchat/config/language_tuerqi.dart';
import 'package:imchat/config/language_yindunixiya.dart';
import 'package:imchat/config/language_yulan.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension Language on String  {

  static final List<Function> _listernArr = [];

  static void addListener(Function item) {
    _listernArr.add(item);
  }

  static void removeListener(Function item) {
    _listernArr.remove(item);
  }


  static void notification() {
    for (var item in _listernArr) {
      item.call();
    }
  }

  static int languageIndex = 0;
  static storeLocal() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("lang_index", languageIndex);
  }

  static initData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    languageIndex = preferences.getInt("lang_index") ?? 0;
  }

  static List<String> get typeArr => [
    "中国".localize,
    "英语".localize,
    "韩国".localize,
    "日本".localize,
    "泰国".localize,
    "土耳其".localize,
    "越南".localize,
    "印度尼西亚".localize,
    "马来西亚".localize,
  ];
  Map<String, String> get languageInfoMap {
    if(languageIndex == 1) {
      return lang_englisgh;
    }else if(languageIndex == 2) {
      return lang_han;
    }else if(languageIndex == 3) {
      return lang_riben;
    }else if(languageIndex == 4) {
      return lang_tai;
    }else if(languageIndex == 5) {
      return lang_tuerqi;
    }else if(languageIndex == 6) {
      return lang_yulan;
    }else if(languageIndex == 7) {
      return lang_yindunixiya;
    }else if(languageIndex == 8) {
      return lang_malai;
    }else {
      return {};
    }
  }

  String get localize {
    String? ret = languageInfoMap[this];
    if(ret?.isNotEmpty == true){
      return ret!;
    }else {
      return this;
    }
  }



}

Map<String, String> lang_englisgh = {
  "复制":"copy",
  "添加好友":"Add a friend",
  "创建群聊":"Create group chat",
  "取消置顶":"Unpin",
  "置顶该聊天":"Pin this chat",
  "标为已读":"Mark as read",
  "设置成功":"Set successfully",
  "已禁言":"Banned",
  "已解除禁言":"Unbanned",
  "已踢出群":"Kicked out of group",
  "取消管理员":"Cancel administrator",
  "设为管理员":"Set as administrator",
  "禁言":"Ban",
  "取消禁言":"Unban",
  "踢出群":"Kick out of group",
  "收藏成功":"Collection successful",
  "复制内容":"Copy content",
  "回复":"Reply",
  "撤回消息":"Withdraw message",
  "收藏":"Collect",
  "复制成功":"Copied successfully",
  "您已禁止权限，需要去设置页面手动开启才能继续":"You have disabled the permission, please enable it!",
  "重试":"Retry",
  "去设置":"Go to Settings",
  "确认":"Confirm",
  "好友申请已发送，请耐心等待回复":"The friend request has been sent, please wait patiently for the reply",
  "请输入留言":"Please enter a message",
  "添加":"Add",
  "请输入内容":"Please enter",
  "正在搜索中哦～":"Searching",
  "未查到相关信息":"No found",
  "搜索好友":"Search for friends",
  "请输入搜索的内容":"Please enter the search",
  "查找":"Search",
  "未找到相关好友":"No related friends found",
  "请选择视频":"Please select a video",
  "请选择图片":"Please select an image",
  "已超过最长录音时间上限，录音已自动停止，需要发送吗":"The maximum recording time has been. Do you need to send",
  "取消":"Cancel",
  "消息撤回":"Recall message",
  "【图片】":"【picture】",
  "【语音】":"【Voice】",
  "【文件】":"【document】",
  "【红包】":"【Red envelope】",
  "【转账】":"【transfer】",
  "语音时间太短, 发送已被取消":"The voice time is too short and has been canceled",
  "点此发送":"Click here to send",
  "取消录制":"Cancel recording",
  "相册":"Album",
  "视频":"Video",
  "拍照":"Photograph",
  "视频聊天":"Video chat",
  "暂未开放":"Not yet open",
  "语音聊天":"Voice chat",
  "拍视频":"Take video",
  "签名":"Sign",
  "群主":"Group owner",
  "管理员":"Administrator",
  "聊天置顶":"Pin",
  "允许全体发言":"Allow all to chat",
  "允许添加好友":"Allow add friends",
  "允许成员退群":"Allow to leave",
  "显示群全成员":"Show all group members",
  "请输入消息":"Please enter message",
  "发送":"Send",
  "正在发送图片,请耐心等待":"Sending pictures...",
  "公告":"Notice",
  "消息":"Message",
  "你确认要解散群吗?":"Make sure disband the group?",
  "你确认要退出群吗?":"Make sure  leave the group?",
  "已解散":"Disbanded",
  "已退出":"Exited",
  "正在上传头像":"Uploading avatar",
  "正在更新数据...":"Updating data...",
  "头像上传失败":"Avatar upload failed",
  "更新头像失败":"Failed to update avatar",
  "确认清除聊天记录?":"Confirm to clear chat history?",
  "删除失败":"failed to delete",
  "群聊信息":"Group information",
  "群聊名称":"Group name",
  "群公告":"Group notice",
  "群成员管理":"Group management",
  "群成员":"Group members",
  "群成员添加":"Add group members",
  "删除聊天记录":"Delete history",
  "群成员删除":"Group member deletion",
  "删除群":"Delete group",
  "退出群":"Exit group",
  "修改备注":"Modification notes",
  "修改昵称":"change username",
  "个性签名":"Signature",
  "提交":"Submit",
  "聊天信息":"Chat information",
  "备注名":"Remark name",
  "申请中":"Applying",
  "同意":"Agree",
  "拒绝":"Reject",
  "留言":"Message",
  "已同意":"Approved",
  "已拒绝":"rejected",
  "通讯录":"Address book",
  "新的好友":"New friends",
  "我的群聊":"My Group Chat",
  "转发成功":"Forwarded successfully",
  "消息转发":"Message forwarding",
  "好友":"Friends",
  "群组":"Group",
  "暂未加入群聊哦!":"Not yet joined the group chat!",
  "好友申请":"Friend application",
  "我的申请":"My application",
  "请输入标题":"Please input title",
  "请选择群头像":"Please select a group avatar",
  "群创建失败":"Group creation failed",
  "群创建成功":"Group created successfully",
  "群名称":"Group name",
  "请输入群名称":"Please enter group name",
  "请输入群公告":"Please enter the group announcement",
  "群头像":"Group avatar",
  "创建":"Create",
  "请选择成员":"Please select a member",
  "删除成功":"successfully deleted",
  "添加成功":"Added successfully",
  "移除":"Remove",
  "请输入用户名":"Please enter username",
  "发现":"Discover",
  "请输入密码":"Please enter password",
  "IM聊天":"IM chat",
  "欢迎您!":"Welcome!",
  "注册账号":"Register an account",
  "登录":"Log in",
  "一键登录":"One-click login",
  "版本号":"version number",
  "已有账号？直接登录":"Already have an account? Log in",
  "注册":"Register",
  "请输入您的昵称":"Please enter your nickname",
  "请输入登录密码":"Please enter your password",
  "注册成功":"Registration success",
  "请输入昵称":"Please enter a nickname",
  "我的":"Mine",
  "再次点击退出":"Click again to exit",
  "IM服务器连接失败":"IM server connection failed",
  "删除":"Delete",
  "转发":"Forward",
  "关于我们":"About Us",
  "商务合作":"Business Cooperation",
  "版本":"Version",
  "客服":"Customer service",
  "中文":"Chinese",
  "英文":"English",
  "切换语言":"Change language",
  "头像修改成功":"Avatar modified successfully",
  "修改资料":"Edit information",
  "用户ID":"User ID",
  "用户名":"Username",
  "昵称":"Nickname",
  "换头像":"Change avatar",
  "您确定要退出账号吗?":"Are you sure you want to logout?",
  "我的收藏":"My favorites",
  "安全设置":"Security Settings",
  "联系客服":"Contact Customer Service",
  "当前版本":"Current version",
  "退出登录":"Log out",
  "账号":"Account",
  "密码不能少于6位":"Password must not be less than 6 characters",
  "两次密码输入不一致":"The two passwords entered are inconsistent",
  "密码修改成功":"Password reset complete",
  "密码设置":"Password settings",
  "请输入新密码":"Please enter a new password",
  "请重新输入新密码":"Please re-enter the new password",
  "设置密码":"Set a password",
};