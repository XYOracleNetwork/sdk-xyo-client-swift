import Foundation

/// JSON-RPC method names for the XL1 chain, ported from the Android `RpcMethodNames`.
public enum RpcMethodNames {
    // BlockViewer
    public static let blockViewerBlocksByHash = "blockViewer_blocksByHash"
    public static let blockViewerBlocksByNumber = "blockViewer_blocksByNumber"
    public static let blockViewerCurrentBlock = "blockViewer_currentBlock"
    public static let blockViewerPayloadsByHash = "blockViewer_payloadsByHash"

    // TransactionViewer
    public static let txViewerByHash = "transactionViewer_byHash"
    public static let txViewerTransactionByHash = "transactionViewer_transactionByHash"
    public static let txViewerByBlockHashAndIndex = "transactionViewer_transactionByBlockHashAndIndex"
    public static let txViewerByBlockNumberAndIndex = "transactionViewer_transactionByBlockNumberAndIndex"

    // AccountBalanceViewer
    public static let accountBalanceViewerQualifiedBalances = "accountBalanceViewer_qualifiedAccountBalances"
    public static let accountBalanceViewerQualifiedHistories = "accountBalanceViewer_qualifiedAccountBalanceHistories"

    // StakeViewer
    public static let stakeViewerById = "stakeViewer_stakeById"
    public static let stakeViewerByStaker = "stakeViewer_stakeByStaker"
    public static let stakeViewerByStaked = "stakeViewer_stakesByStaked"
    public static let stakeViewerStakesByStaker = "stakeViewer_stakesByStaker"
    public static let stakeViewerMinWithdrawalBlocks = "stakeViewer_minWithdrawalBlocks"
    public static let stakeViewerRewardsContract = "stakeViewer_rewardsContract"
    public static let stakeViewerStakingTokenAddress = "stakeViewer_stakingTokenAddress"

    // MempoolViewer
    public static let mempoolViewerPendingTransactions = "mempoolViewer_pendingTransactions"
    public static let mempoolViewerPendingBlocks = "mempoolViewer_pendingBlocks"

    // MempoolRunner
    public static let mempoolRunnerSubmitTransactions = "mempoolRunner_submitTransactions"
    public static let mempoolRunnerSubmitBlocks = "mempoolRunner_submitBlocks"

    // FinalizationViewer
    public static let finalizationViewerHead = "finalizationViewer_head"

    // TimeSyncViewer
    public static let timeSyncViewerConvertTime = "timeSyncViewer_convertTime"
    public static let timeSyncViewerCurrentTime = "timeSyncViewer_currentTime"
    public static let timeSyncViewerCurrentTimeAndHash = "timeSyncViewer_currentTimeAndHash"
    public static let timeSyncViewerCurrentTimePayload = "timeSyncViewer_currentTimePayload"

    // NetworkStakeViewer
    public static let networkStakeViewerActive = "networkStakeViewer_active"

    // TransferBalanceViewer
    public static let transferBalanceViewerBalance = "transferBalanceViewer_transferBalance"
    public static let transferBalanceViewerHistory = "transferBalanceViewer_transferBalanceHistory"
    public static let transferBalanceViewerBalances = "transferBalanceViewer_transferBalances"
    public static let transferBalanceViewerPairBalance = "transferBalanceViewer_transferPairBalance"
    public static let transferBalanceViewerPairHistory = "transferBalanceViewer_transferPairBalanceHistory"
    public static let transferBalanceViewerPairBalances = "transferBalanceViewer_transferPairBalances"

    // StakeTotalsViewer
    public static let stakeTotalsViewerActive = "stakeTotalsViewer_active"
    public static let stakeTotalsViewerActiveByStaked = "stakeTotalsViewer_activeByStaked"
    public static let stakeTotalsViewerActiveByStaker = "stakeTotalsViewer_activeByStaker"
    public static let stakeTotalsViewerPending = "stakeTotalsViewer_pending"
    public static let stakeTotalsViewerPendingByStaker = "stakeTotalsViewer_pendingByStaker"
    public static let stakeTotalsViewerWithdrawn = "stakeTotalsViewer_withdrawn"
    public static let stakeTotalsViewerWithdrawnByStaker = "stakeTotalsViewer_withdrawnByStaker"

    // BlockRewardViewer
    public static let blockRewardViewerAllowedReward = "blockRewardViewer_allowedRewardForBlock"

    // StakeRunner
    public static let stakeRunnerAddStake = "stakeRunner_addStake"
    public static let stakeRunnerRemoveStake = "stakeRunner_removeStake"
    public static let stakeRunnerWithdrawStake = "stakeRunner_withdrawStake"

    // StepViewer
    public static let stepViewerPositionCount = "stepViewer_positionCount"
    public static let stepViewerPositions = "stepViewer_positions"
    public static let stepViewerRandomizer = "stepViewer_randomizer"
    public static let stepViewerStake = "stepViewer_stake"
    public static let stepViewerStakerCount = "stepViewer_stakerCount"
    public static let stepViewerStakers = "stepViewer_stakers"
    public static let stepViewerWeight = "stepViewer_weight"

    // ForkViewer
    public static let forkViewerForkHistory = "forkViewer_forkHistory"

    // DataLakeViewer
    public static let dataLakeViewerGet = "dataLakeViewer_get"
    public static let dataLakeViewerNext = "dataLakeViewer_next"
}
