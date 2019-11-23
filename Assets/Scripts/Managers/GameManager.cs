using UnityEngine;
using UnityEngine.UI;

namespace Noc7c9.DyeDontDie {

    public class GameManager : MonoBehaviour {

        public PlayerController player;
        public LevelLoader levelLoader;

        public RectTransform startMenu;
        public RectTransform gameOver;

        public InputManager input;

        enum State {
            START_MENU, IN_GAME, GAME_OVER
        }
        State state;

        // Vector3 initialPlayerPosition;
        Rigidbody2D playerRb;

        void Start() {
            // initialPlayerPosition = player.transform.position;
            playerRb = player.GetComponent<Rigidbody2D>();
            playerRb.constraints = RigidbodyConstraints2D.None;
            playerRb.AddTorque(10);

            state = State.START_MENU;

            startMenu.gameObject.SetActive(true);
            gameOver.gameObject.SetActive(false);

            player.Died -= OnPlayerDiedHandler;
            player.Died += OnPlayerDiedHandler;
        }

        void Update() {
            var startDown = input.GetStartDown();

            switch (state) {
                case State.START_MENU:
                case State.GAME_OVER:
                    if (startDown) {
                        StartGame();
                    }
                break;
            }
        }

        void StartGame() {
            startMenu.gameObject.SetActive(false);
            gameOver.gameObject.SetActive(false);

            player.Reset();

            levelLoader.StartLoading();

            state = State.IN_GAME;
        }

        void OnPlayerDiedHandler() {
            gameOver.gameObject.SetActive(true);

            levelLoader.StopLoading();

            state = State.GAME_OVER;
        }

    }

}
