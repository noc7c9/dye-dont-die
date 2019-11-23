using UnityEngine;

namespace Noc7c9.DyeDontDie {

    public class ServiceLocator {

        private static GameManager gameManager;
        public static GameManager GameManager {
            get {
                if (gameManager == null) {
                    gameManager = MonoBehaviour.FindObjectOfType<GameManager>();
                }
                return gameManager;
            }
        }

        private static AudioManager audioManager;
        public static AudioManager AudioManager {
            get {
                if (audioManager == null) {
                    audioManager = MonoBehaviour.FindObjectOfType<AudioManager>();
                }
                return audioManager;
            }
        }

        private static InputManager inputManager;
        public static InputManager InputManager {
            get {
                if (inputManager == null) {
                    inputManager = MonoBehaviour.FindObjectOfType<InputManager>();
                }
                return inputManager;
            }
        }

        private static WorldColorManager worldColorManager;
        public static WorldColorManager WorldColorManager {
            get {
                if (worldColorManager == null) {
                    worldColorManager = MonoBehaviour.FindObjectOfType<WorldColorManager>();
                }
                return worldColorManager;
            }
        }

    }

}
