# E-Card
An in-development iOS app that simulates the *E-Card* game from the anime *Gyakkyō Burai Kaiji: Ultimate Survivor*. It is a **2-player turn-based game**.


The app is being built using **SwiftUI** and uses **GameKit** for multiplayer functionality.

## Gameplay Rules

The game is centered around three types of cards, each symbolizing a role in a simplified version of society:

- **Emperor (koutei):** Represents ultimate power and wealth. The Emperor card defeats Citizen cards.
- **Citizen (shimin):** Represents the common people who seek wealth but are subservient to the Emperor. Citizen cards lose to the Emperor but defeat the Slave.
- **Slave (dorei):** Represents those with nothing to lose and no desire for wealth. The Slave card defeats the Emperor but loses to Citizen cards.

### Card Distribution
- **Emperor Side:** Four Citizen cards and one Emperor card.
- **Slave Side:** Four Citizen cards and one Slave card.

Since the Slave Side has a harder time winning (Slave cards only defeat Emperor cards), the Slave Side earns five times the winnings if victorious.

---

### Game Flow
Each game consists of **12 matches**, grouped into **4 groups of 3 rounds**. Each group alternates which player is the Emperor Side. The rounds proceed as follows:

#### Round Flow:
1. The **Emperor Side** places a card face down first.
2. The **Slave Side** then places a card face down.
3. Both cards are revealed, and the winner is determined based on the card rules:
   - Emperor beats Citizen.
   - Citizen beats Slave.
   - Slave beats Emperor.

#### Handling Draws:
- **First Draw:** Cards are removed, and the **Slave Side** plays a card first in the next play.
- **Second Draw:** Cards are removed again, and the **Emperor Side** plays a card first in the final play of the round.
- **Third Draw:** If a draw occurs in the final play, the round concludes without a winner.

After each round:
- All played cards are collected.
- The next round begins, alternating which side plays the first card.

---

### Group of Rounds
- **1st Group of 3 Rounds:** Emperor Side plays first in the first round.
- **2nd Group of 3 Rounds:** The roles switch; the Slave Side becomes the Emperor Side, and vice versa.
- **3rd and 4th Groups of 3 Rounds:** Roles alternate after each group.

---

### Winning the Game
- After all **12 matches** have been played:
  - The player with the most victories wins the game.
