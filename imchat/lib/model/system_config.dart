

SystemConfigBefore? allConfigBeModel;
SystemConfigAfter? allConfigAfModel;
class SystemConfigBefore {

  int? memberAppRegisterSwitch; //开放注册(手机客户端)(0-开 1-关)
  int? memberAutoRegisterSwitch;//一键注册(0-开 1-关)
  int? memberPCRegisterSwitch; //开放注册(PC户端)(0-开 1-关)
  int? memberRegisterCodeRequiredSwitch; //邀请码必填(0-开 1-关)
  int? memberRegisterCodeSwitch; //注册邀请码(0-开 1-关)

  SystemConfigBefore.fromJson(Map<String, dynamic> json) {
    memberAppRegisterSwitch = json['memberAppRegisterSwitch'];
    memberAutoRegisterSwitch = json['memberAutoRegisterSwitch'];
    memberPCRegisterSwitch = json['memberPCRegisterSwitch'];
    memberRegisterCodeRequiredSwitch = json['memberRegisterCodeRequiredSwitch'];
    memberRegisterCodeSwitch = json['memberRegisterCodeSwitch'];
  }

}

class SystemConfigAfter {

  String? appIndexContent; // APP首页内容
  int? memberIdSwitch;//显示账号ID开关(0-开 1-关)
  int? memberMessageInputStatusSwitch; //是否显示输入状态(0-开 1-关)
  int? memberMessageReadStatusSwitch;//显示消息阅读状态(0-开 1-关)
  int? memberOnLineStatusSwitch;//显示在线状态(0-开 1-关)
  int? rechargeMinAmount;//最低充值金额
  int? rechargeSwitch;//充值功能(0-开 1-关)
  int? redPackBlessingsContentSwitch;//红包自定义红包祝福语(0-关 1-管理号开 2所有人)
  int? redPackGroupMaxAmount;//群红包最大金额
  int? redPackGroupMinAmount;//群红包最低金额
  int? redPackGroupSwitch;//群红包功能(0-关 1-管理号开 2所有人)
  int? redPackMemberMaxAmount;//个人红包最大金额
  int? redPackMemberMinAmount;//个人红包最低金额
  int? redPackMemberSwitch;//个人红包功能(0-关 1-管理号开 2所有人)
  int? redPackOverTime;//红包超时时间(单位小时)
  int? rersonalitySignSwitch;//显示会员签名开关(0-开 1-关)
  int? showGroupInfoByMemberSwitch;//允许普通用户查看群信息(0-开 1-关)
  int? showGroupMemberNumSwitch;//群标题是否显示群人数(0-开 1-关)
  int? showGroupMemberSwitch;//群信息界面是否显示群成员(0-开 1-关)
  int? showGroupRequestMessageSwitch;//显示邀请入群消息(0-开 1-关)
  int? showRedpackInfoSwitch;//是否显示红包领取详情(0-开 1-关)
  int? transferMaxAmount;//单笔转账最大金额
  int? transferMinAmount;//单笔转账最低金额
  int? walletSwitch;//钱包功能(0-开 1-关)
  int? withdrawCashMinAmount;//最低充值金额
  int? withdrawCashSwitch;//提现功能(0-开 1-关)

  SystemConfigAfter.fromJson(Map<String, dynamic> json) {
    appIndexContent = json['appIndexContent'];
    memberIdSwitch = json['memberIdSwitch'];
    memberMessageInputStatusSwitch = json['memberMessageInputStatusSwitch'];
    memberMessageReadStatusSwitch = json['memberMessageReadStatusSwitch'];
    memberOnLineStatusSwitch = json['memberOnLineStatusSwitch'];
    rechargeMinAmount = json['rechargeMinAmount'];
    rechargeSwitch = json['rechargeSwitch'];
    redPackBlessingsContentSwitch = json['redPackBlessingsContentSwitch'];
    redPackGroupMaxAmount = json['redPackGroupMaxAmount'];
    redPackGroupMinAmount = json['redPackGroupMinAmount'];
    redPackGroupSwitch = json['redPackGroupSwitch'];
    redPackMemberMaxAmount = json['redPackMemberMaxAmount'];
    redPackMemberMinAmount = json['redPackMemberMinAmount'];
    redPackMemberSwitch = json['redPackMemberSwitch'];
    redPackOverTime = json['redPackOverTime'];
    rersonalitySignSwitch = json['rersonalitySignSwitch'];
    showGroupInfoByMemberSwitch = json['showGroupInfoByMemberSwitch'];
    showGroupMemberNumSwitch = json['showGroupMemberNumSwitch'];
    showGroupMemberSwitch = json['showGroupMemberSwitch'];
    showGroupRequestMessageSwitch = json['showGroupRequestMessageSwitch'];
    showRedpackInfoSwitch = json['showRedpackInfoSwitch'];
    transferMaxAmount = json['transferMaxAmount'];
    transferMinAmount = json['transferMinAmount'];
    walletSwitch = json['walletSwitch'];
    withdrawCashMinAmount = json['withdrawCashMinAmount'];
    withdrawCashSwitch = json['withdrawCashSwitch'];

  }

}