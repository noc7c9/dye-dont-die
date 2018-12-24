using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Noc7c9.DyeDontDie {

    public class GameManager : MonoBehaviour {

        static GameManager instance_;
        public static GameManager Instance {
            get {
                if (instance_ == null) {
                    instance_ = FindObjectOfType<GameManager>();
                }
                return instance_;
            }
        }

        public PlayerController player;
        public LevelLoader levelLoader;
        public CameraFollow camera;

        public RectTransform startMenu;
        public RectTransform gameOver;

        public Color[] colors;

        public InputManager input;

        [SerializeField]
        int activeColorIndex;

        public Color GetActiveColor() {
            return colors[activeColorIndex];
        }
        public Color GetColorSafe(int index) {
            return colors[index % colors.Length];
        }
        public int GetNumberOfColors() {
            return colors.Length;
        }
        public bool MatchesActiveColor(Color color) {
            return color == GetActiveColor();
        }

        void OnValidate() {
            activeColorIndex = Mathf.Clamp(activeColorIndex, 0, colors.Length);
        }

        public event System.Action<Color> ChangedColor;
        void OnChangedColor() {
            var evt = ChangedColor;
            if (evt != null) {
                evt(GetActiveColor());
            }
        }

        enum State {
            START_MENU, IN_GAME, GAME_OVER
        }
        State state;

        // Vector3 initialPlayerPosition;
        Rigidbody2D playerRb;

        void Start() {
            UpdateColors();

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
            bool startDown = input.GetStartDown();

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

        public void UpdateColors() {
            Camera.main.backgroundColor = GetActiveColor();
        }

        public void CycleColor() {
            activeColorIndex = (activeColorIndex + 1) % colors.Length;
            OnChangedColor();
            UpdateColors();
        }

    }

}
