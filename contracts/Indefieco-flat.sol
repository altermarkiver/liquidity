// File: @openzeppelin\upgrades\contracts\Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: contracts\interfaces\IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts\token\ERC20\ERC20Detailed.sol

pragma solidity ^0.5.0;




/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is Initializable, IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    uint256[50] private ______gap;
}

// File: contracts\nonupgradable\Ownable.sol

pragma solidity ^0.5.16;

contract Ownable {
    address payable public owner;
    address payable internal newOwnerCandidate;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Permission denied");
        _;
    }

    function changeOwner(address payable newOwner) public onlyOwner {
        newOwnerCandidate = newOwner;
    }

    function acceptOwner() public {
        require(msg.sender == newOwnerCandidate, "Permission denied");
        owner = newOwnerCandidate;
    }
}

// File: contracts\interfaces\IToken.sol

pragma solidity ^0.5.16;

interface IToken {
    function decimals() external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function approve(address spender, uint value) external;
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function deposit() external payable;
    function mint(address, uint256) external;
    function withdraw(uint amount) external;
    function totalSupply() view external returns (uint256);
    function burnFrom(address account, uint256 amount) external;
    function symbol() external view returns (string memory);
}

// File: contracts\utils\SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts\token\ERC20\ERC20.sol

pragma solidity ^0.5.0;





/**
 * @dev Implementation of the {IERC20} interface.
 */
contract ERC20 is Initializable, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;

    mapping (address => mapping (address => uint256)) internal _allowances;

    uint256 internal _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
    }

    uint256[50] private ______gap;
}

// File: contracts\interfaces\IPriceOracle.sol

pragma solidity ^0.5.17;

interface IPriceOracle {
    function price(string calldata symbol) external view returns (uint);
}

// File: contracts\utils\DSMath.sol

pragma solidity ^0.5.0;

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

//    function min(uint x, uint y) internal pure returns (uint z) {
//        return x <= y ? x : y;
//    }
//    function max(uint x, uint y) internal pure returns (uint z) {
//        return x >= y ? x : y;
//    }
//    function imin(int x, int y) internal pure returns (int z) {
//        return x <= y ? x : y;
//    }
//    function imax(int x, int y) internal pure returns (int z) {
//        return x >= y ? x : y;
//    }

    uint constant WAD = 10 ** 18;
//    uint constant RAY = 10 ** 27;

    function wmul(uint x, uint y, uint base) internal pure returns (uint z) {
        z = add(mul(x, y), base / 2) / base;
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
//    function rmul(uint x, uint y) internal pure returns (uint z) {
//        z = add(mul(x, y), RAY / 2) / RAY;
//    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
//    function rdiv(uint x, uint y) internal pure returns (uint z) {
//        z = add(mul(x, RAY), y / 2) / y;
//    }

}

// File: contracts\deposits_v3\Indefieco.sol

pragma solidity ^0.5.16;







interface TokenizedStrategy {
    function deposit(uint256 amountDAI, uint256 amountUSDC, address flashloanFromAddress) external payable;
    function burnTokens(uint256 amountDAI, uint256 amountUSDC, uint256 amountETH, address flashLoanFromAddress) external;
    function userClaimProfit(uint64 max) external;
    function burnTokens(uint256 amount, bool withFlashloan) external; // function from old TokenizedStrategy, work just for DAI
}

interface IComptroller {
    function oracle() external view returns (IPriceOracle);
    function getAccountLiquidity(address) external view returns (uint, uint, uint);
}



contract InDefiEcoPreMining is
    Ownable,
    ERC20Detailed,
    ERC20,
    DSMath
{
    address public constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant COMPTROLLER = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;

    TokenizedStrategy public constant dfTokenizedStrategy = TokenizedStrategy(0xb942ca22e0eb0f2524F53f999aE33fD3B2D58E3E);
    address public constant dfDeposits = 0xFff9D7b0B6312ead0a1A993BF32f373449006F2F;

    constructor() public {
        // Initialize Parents Contracts
        owner = msg.sender;
        ERC20Detailed.initialize('XIDF', 'XIDF', 18);
        maxDateDeposits = now + 30 days;    // TODO: финализировать на конкретную дату\число
        dateFundsUnlocked = now + 180 days; // TODO: финализировать на конкретную дату\число
    }

    mapping(address => bool) tokens;

    struct Deposit  {
        uint256 amount;
        uint256 avgPrice;
        uint256 tokensToMint;
    }
    mapping(address => mapping(address => Deposit)) userDeposits;

    uint256 public maxDateDeposits;
    uint256 public dateFundsUnlocked;
    address flashloanFromAddress;
    uint256 public constant totalMaxTokens = 20000000 * 1e18; // 20 mil
    uint256 public totalCurrentTokens;

    function getInfo(address userAddress, address tokenAddress) view public returns ( uint256 amount, uint256 avgPrice,uint256 tokensToMint, uint256 price, uint256 balance) {
        IPriceOracle compOracle = IComptroller(COMPTROLLER).oracle();
        price = compOracle.price(IToken(tokenAddress).symbol());
        balance = IToken(tokenAddress).balanceOf(address(this));

        Deposit memory d = userDeposits[userAddress][tokenAddress];
        amount = d.amount;
        avgPrice = d.avgPrice;
        tokensToMint = d.tokensToMint;
    }

    function enableToken(address tokenAddress) public onlyOwner {
        tokens[tokenAddress] = true;
    }

    function fundsToTokensUsePrice(IToken token, uint256 price, uint256 amount) view public returns (uint256) {
        uint256 decimals = token.decimals();
        return price * amount / 10 ** decimals * 10**(18 - decimals);
    }

    function deposit(IToken token, uint256 amount) payable public returns (uint256) {
        require(now < maxDateDeposits);
        require(tokens[address(token)]);
        IPriceOracle compOracle = IComptroller(COMPTROLLER).oracle();
        uint256 _price = compOracle.price(token.symbol());
        require(_price > 0);
        if (address(token) == ETH_ADDRESS) {
            require(msg.value == amount);
        } else {
            token.transferFrom(msg.sender, address(this), amount);
        }

        uint256 tokensToMint = fundsToTokensUsePrice(token,_price, amount);
        totalCurrentTokens = add(totalCurrentTokens, tokensToMint);
        require(totalCurrentTokens <= totalMaxTokens);

        Deposit storage depo = userDeposits[msg.sender][address(token)];
        uint256 totalAmount = depo.amount;
        uint256 newAvgPrice = add(totalAmount * depo.avgPrice, _price * amount) / (totalAmount + amount);
        depo.amount = totalAmount + amount;
        depo.avgPrice = newAvgPrice;
        depo.tokensToMint = add(depo.tokensToMint, tokensToMint);

        return tokensToMint;
    }

    function releaseTokens(address userAddress, address[] memory tokenList) public returns (uint256 tokensToMint){
        require(now >= maxDateDeposits);

        if (userAddress == address(0)) userAddress = msg.sender;
        uint256 len = tokenList.length;

        uint256 _totalMaxTokens = totalMaxTokens;
        uint256 _totalCurrentTokens = totalCurrentTokens;

        for(uint256 i = 0; i < len;i++) {
            Deposit storage depo = userDeposits[userAddress][tokenList[i]];
            uint256 _tMint = depo.tokensToMint;
            if (_tMint > 0) {
                tokensToMint = add(tokensToMint, _tMint);
                // увеличиваем среднюю цену за актив пропорционально полученным токенам
                depo.avgPrice = depo.avgPrice * _totalMaxTokens / _totalCurrentTokens;
                depo.tokensToMint = 0;
            }
        }
        if (tokensToMint > 0) {
            // токены распределяются пропорционально
            tokensToMint = tokensToMint * _totalMaxTokens / _totalCurrentTokens;
            _mint(userAddress, tokensToMint);
        }
    }

    function withdraw(address token, uint256 amount) public returns (uint256 tokensToBurn) {
        require(tokens[token]); // token enabled

        Deposit storage depo = userDeposits[msg.sender][token];
        require(depo.tokensToMint == 0);
        // до dateFundsUnlocked необходимо вернуть токены для возврата средств
        if (now < dateFundsUnlocked) {
            tokensToBurn = fundsToTokensUsePrice(IToken(token), depo.avgPrice, amount);
            _burnFrom(msg.sender, tokensToBurn);
        }

        depo.amount = sub(depo.amount, amount);

        withdrawToken(IToken(token), amount, msg.sender);

        return tokensToBurn;
    }

    function approveTokens(address[] memory listTokens) public onlyOwner {
        for(uint256 i = 0; i < listTokens.length;i++) {
            IToken token = IToken(listTokens[i]);
            if (token.allowance(address(this), address(dfTokenizedStrategy)) != uint256(-1)) {
                token.approve(address(dfTokenizedStrategy), uint256(-1));
            }
        }
    }

    function externalCallToTokenizedStrategy(address payable target, bytes memory data, uint256 ethAmount) public onlyOwner returns(bytes32 response) {
        // вызовы разрешены только на 2 контракта по управлению средствами
        require(target == dfDeposits || target == address(dfTokenizedStrategy));
        assembly {
            let succeeded := call(sub(gas, 5000), target, ethAmount, add(data, 0x20), mload(data), 0, 32)
            response := mload(0)
            switch iszero(succeeded)
            case 1 {
                revert(0, 0)
            }
        }
    }

    function _transferEth(address receiver, uint256 amount) internal {
        address payable receiverPayable = address(uint160(receiver));
        (bool result, ) = receiverPayable.call.value(amount)("");
        require(result, "Transfer of ETH failed");
    }

    function withdrawToken(IToken token, uint256 amount, address receiver) internal {
        if (receiver != address(this)) {
            if (address(token) == ETH_ADDRESS) {
                _transferEth(receiver, amount);
                return;
            } else if (token.balanceOf(address(this)) >= amount) {
                token.transfer(receiver, amount);
                return;
            }
        }

        if (address(token) == DAI_ADDRESS) {
            // dfTokenizedStrategy.burnTokens(amount, 0, 0, flashloanFromAddress);
            dfTokenizedStrategy.burnTokens(amount, true); // старая версия tokenizedDeposits, можно в новой доавить функцию с такой же сигнатурой
            if (receiver != address(this)) token.transfer(receiver, amount);
        } else if (address(token) == ETH_ADDRESS) {
            dfTokenizedStrategy.burnTokens(0, 0, amount, flashloanFromAddress);
            if (receiver != address(this)) _transferEth(receiver, amount);
        } else {
            require(false);
        }
    }

    // allow to claim profit from tokenized startegy (in new version)
    function defiController() view external returns(address) {
        return owner;
    }
}
