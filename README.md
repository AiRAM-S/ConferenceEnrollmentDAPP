# **Conference Enrollment DApp**

## **项目简介**
Conference Enrollment DApp 是一个基于以太坊的去中心化应用，允许用户创建和管理会议。该项目实践了如何结合智能合约和前端技术开发一个完整的区块链应用。

主要功能包括：
- 创建会议
- 查看可报名的会议
- 报名参加会议
- 监听会议相关事件（如会议创建和过期）
- （调试中）委托注册用户代理报名会议

## **技术栈**
- **前端**: React.js, Ant Design, Semantic UI
- **区块链**: Solidity, Web3.js
- **开发工具**: Truffle, Ganache, Metamask
- **运行环境**: Node.js

## **目录结构**
```plaintext
ConferenceEnrollmentDApp/
├── instruction/         # 本项目的实验指导文件
├── lab8/                # Truffle 项目
│   ├── contracts/       # 智能合约源码
│   │   ├── Enrollment.sol    
│   │   ├── ...
│   ├── test/            # 测试合约
│   ├── migrations/      # 合约迁移脚本
│   └── truffle-config.js      # Truffle 配置文件
├── lab7-frontend/       # 前端源代码
│   ├── components/      # React 组件
│   ├── contracts/       # 合约 ABI 和交互逻辑
│   ├── App.js           # 应用入口
│   ├── ...              # 其余create-react-app生成的文件
└── report.md            # 实验报告
```

## **功能特性**
1. **创建会议**  
   用户可设置会议标题、详情、人数限制，并通过智能合约保存到区块链。
   
2. **查看会议列表**  
   可通过前端界面查看当前可报名的会议。

3. **报名会议**  
   用户可以报名参加会议，更新会议当前参与人数并监听会议是否达到人数上限。

4. **事件监听**  
   - 新会议创建 (`NewConference`)
   - 会议过期 (`ConferenceExpire`)
   - 用户报名新会议（`MyNewConference`）

## **安装与运行**
### **前置条件**
1. Node.js (建议使用 v16+)
2. Truffle 和 Ganache
3. Metamask 浏览器插件

### **克隆项目**
```bash
git clone https://github.com/AiRAM-S/ConferenceEnrollmentDAPP
cd ConferenceEnrollmentDAPP
```

### **安装依赖**
```bash
npm install
```

### **连接区块链网络**
- 确保 Ganache 正常运行。
- 使用 Metamask 配置连接本地区块链网络。

### **配置智能合约**
1. 使用 Truffle 编译并部署合约：
   ```bash
   cd lab8
   truffle compile
   truffle migrate
   ```
2. 将部署后生成的 `Enrollment.json` 中的ABI替换到 `src/contracts/contract.js`，并修改`contract.js`中的合约地址为合约部署在Ganache的地址。

### **启动前端**
```bash
npm start
```
访问 `http://localhost:3000` 查看应用。

