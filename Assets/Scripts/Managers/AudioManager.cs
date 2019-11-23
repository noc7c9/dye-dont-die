using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    public class AudioManager : MonoBehaviour {

        public AudioSource music;
        public AudioSource source;

        public void PlaySound(AudioClip clip) {
            if (clip != null) {
                source.PlayOneShot(clip);
            }
        }

        public static void PlaySoundStatic(AudioClip clip) {
            ServiceLocator.AudioManager.PlaySound(clip);
        }

        public void SetMusicVolume(float volume) {
            music.volume = volume;
        }

    }

}
