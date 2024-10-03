// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const crowdFunding = buildModule("crowdFunding", (m) => {

  const crowdfunding = m.contract("Crowdfunding");

  return { crowdfunding };
});

export default crowdFunding;
