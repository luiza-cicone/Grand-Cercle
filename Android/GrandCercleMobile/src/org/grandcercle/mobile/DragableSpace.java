package org.grandcercle.mobile;

import android.content.Context;
import android.content.res.TypedArray;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.widget.Scroller;

public class DragableSpace extends ViewGroup {
    private Scroller mScroller;
    private VelocityTracker mVelocityTracker;

    private int mScrollX = 0;
    private int mCurrentScreen = 0;

    private float mLastMotionX;

    private static final int SNAP_VELOCITY = 1000;

    private final static int TOUCH_STATE_REST = 0;
    private final static int TOUCH_STATE_SCROLLING = 1;

    private int mTouchState = TOUCH_STATE_REST;

    private int mTouchSlop = 0;

    public DragableSpace(Context context) {
   
        super(context);
        mScroller = new Scroller(context);

        mTouchSlop = ViewConfiguration.get(getContext()).getScaledTouchSlop();

        this.setLayoutParams(new ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.WRAP_CONTENT,
                    ViewGroup.LayoutParams.FILL_PARENT));
    }

    public DragableSpace(Context context, AttributeSet attrs) {
        super(context, attrs);
        mScroller = new Scroller(context);

        mTouchSlop = ViewConfiguration.get(getContext()).getScaledTouchSlop();

        this.setLayoutParams(new ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.WRAP_CONTENT ,
                    ViewGroup.LayoutParams.FILL_PARENT));

        TypedArray a=getContext().obtainStyledAttributes(attrs,R.styleable.DragableSpace);
        mCurrentScreen = a.getInteger(R.styleable.DragableSpace_default_screen, 0);
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        /*
         * Cette méthode détermine si on doit intercepter le mouvement.
         * Si on retourne true, onTouchEvent sera appelé et on fait le scroll
         */

        /*
         * Shortcut the most recurring case: l'utilisateur est dans l'état drag et est en train de bouger
         *son doigt sur l'écran. On veut donc intercepter le mouvement.
         */
        final int action = ev.getAction();
        if ((action == MotionEvent.ACTION_MOVE) && (mTouchState != TOUCH_STATE_REST)) {
        	return true;
        }

        final float x = ev.getX();

        switch (action) {
            case MotionEvent.ACTION_MOVE:
                /*
                 * mIsBeingDragged == false, sinon on a déja capturé le mouvement. On vérifie si
                 * l'utilisateur a bougé assez vite à partir de l'endroit où il a touché l'écran.
                 */

                /*
                 * Locally do absolute value. mLastMotionX est mis à l'ordonnée de l'ancien mouvement
                 * intercepté.
                 */
                final int xDiff = (int) Math.abs(x - mLastMotionX);

                boolean xMoved = xDiff > mTouchSlop;

                if (xMoved) {
                    // Scroll si l'utilisateur slide assez vite sur l'axe des abscisses.
                    mTouchState = TOUCH_STATE_SCROLLING;
                }
                break;

            case MotionEvent.ACTION_DOWN:
                // mémorisation de la dernière valeur
                mLastMotionX = x;
                mTouchState = mScroller.isFinished() ? TOUCH_STATE_REST : TOUCH_STATE_SCROLLING;
                break;

            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_UP:
                // Abandon du drag
                mTouchState = TOUCH_STATE_REST;
                break;
        }

        /*
         * On veut interpreter le mouvement uniquement quand on est dans le
         * drag mode.
         */
        return mTouchState != TOUCH_STATE_REST;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (mVelocityTracker == null) {
            mVelocityTracker = VelocityTracker.obtain();
        }
        mVelocityTracker.addMovement(event);

        final int action = event.getAction();
        final float x = event.getX();

        switch (action) {
            case MotionEvent.ACTION_DOWN:
                
                if (!mScroller.isFinished()) {
                    mScroller.abortAnimation();
                }

                // Sauvegarde l'endroit ou le mouvement a commencé
                mLastMotionX = x;
                break;
            case MotionEvent.ACTION_MOVE:
                // Scroll pour poursuivre le mouvement
                final int deltaX = (int) (mLastMotionX - x);
                mLastMotionX = x;


                if (deltaX < 0) {
                    if (mScrollX > 0) {
                        scrollBy(Math.max(-mScrollX, deltaX), 0);
                    }
                } else if (deltaX > 0) {
                    final int availableToScroll = getChildAt(getChildCount() - 1)
                        .getRight()
                        - mScrollX - getWidth();
                    if (availableToScroll > 0) {
                        scrollBy(Math.min(availableToScroll, deltaX), 0);
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
                final VelocityTracker velocityTracker = mVelocityTracker;
                velocityTracker.computeCurrentVelocity(1000);
                int velocityX = (int) velocityTracker.getXVelocity();

                if (velocityX > SNAP_VELOCITY && mCurrentScreen > 0) {
                    // Mouvement assez fort pour aller vers la gauche
                    snapToScreen(mCurrentScreen - 1);
                } else if (velocityX < -SNAP_VELOCITY && mCurrentScreen < getChildCount() - 1) {
                    // Mouvement assez fort pour aller vers la gauche
                    snapToScreen(mCurrentScreen + 1);
                } else {
                    snapToDestination();
                }

                if (mVelocityTracker != null) {
                    mVelocityTracker.recycle();
                    mVelocityTracker = null;
                }
                mTouchState = TOUCH_STATE_REST;
                break;
            case MotionEvent.ACTION_CANCEL:
                mTouchState = TOUCH_STATE_REST;
        }
        mScrollX = this.getScrollX();

        return true;
    }

    private void snapToDestination() {
        final int screenWidth = getWidth();
        final int whichScreen = (mScrollX + (screenWidth / 2)) / screenWidth;
        snapToScreen(whichScreen);
    }

    public void snapToScreen(int whichScreen) {     
        mCurrentScreen = whichScreen;
        final int newX = whichScreen * getWidth();
        final int delta = newX - mScrollX;
        mScroller.startScroll(mScrollX, 0, delta, 0, Math.abs(delta) * 2);             
        invalidate();
    }

    public void setToScreen(int whichScreen) {
        mCurrentScreen = whichScreen;
        final int newX = whichScreen * getWidth();
        mScroller.startScroll(newX, 0, 0, 0, 10);             
        invalidate();
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        int childLeft = 0;
        final int count = getChildCount();
        for (int i = 0; i < count; i++) {
            final View child = getChildAt(i);
            if (child.getVisibility() != View.GONE) {
                final int childWidth = child.getMeasuredWidth();
                child.layout(childLeft, 0, childLeft + childWidth, child
                        .getMeasuredHeight());
                childLeft += childWidth;
            }
        }

    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        final int width = MeasureSpec.getSize(widthMeasureSpec);
        final int widthMode = MeasureSpec.getMode(widthMeasureSpec);
        if (widthMode != MeasureSpec.EXACTLY) {
            throw new IllegalStateException("error mode.");
        }

        // On donne aux fils la meme longueur et largeur que l'espace de travail
        final int count = getChildCount();
        for (int i = 0; i < count; i++) {
            getChildAt(i).measure(widthMeasureSpec, heightMeasureSpec);
        }
        scrollTo(mCurrentScreen * width, 0);      
    }  

    @Override
    public void computeScroll() {
        if (mScroller.computeScrollOffset()) {
            mScrollX = mScroller.getCurrX();
            scrollTo(mScrollX, 0);
            postInvalidate();
        }
    }
 
    /**
     * Retourne l'instance qui doit etre sauvegardée
     */
    @Override
    protected Parcelable onSaveInstanceState() {
    	final SavedState state = new SavedState(super.onSaveInstanceState());
    	state.currentScreen = mCurrentScreen;
    	return state;
    }


    /**
     * Met à jour l'ecran actuel sauvegardé
     */
    @Override
    protected void onRestoreInstanceState(Parcelable state) {
    	SavedState savedState = (SavedState) state;
    	super.onRestoreInstanceState(savedState.getSuperState());
    	if (savedState.currentScreen != -1) {
    		mCurrentScreen = savedState.currentScreen;
    	}
    }

    // ========================= CLASSES INTERNES==============================

    public interface onViewChangedEvent{      
    	void onViewChange (int currentViewIndex);
    }

    /**
     * Un etat sauvegardé qui sauve et charge l'écran actuel
     */
    public static class SavedState extends BaseSavedState {
    	int currentScreen = -1;

      	/**
       	* Constructeur interne
       	* 
       	* @param superState
       	*/
      	SavedState(Parcelable superState) {
      		super(superState);
      	}

      	/**
      	 * Constructeur privé
      	 * 
      	 * @param in
      	 */
      	private SavedState(Parcel in) {
      		super(in);
        	currentScreen = in.readInt();
      	}

      	/**
       	* Sauvegarde l'écran actuel
       	*/
      	@Override
      	public void writeToParcel(Parcel out, int flags) {
    	  	super.writeToParcel(out, flags);
        	out.writeInt(currentScreen);
      	}

		/**
		 * Retourne un créateur parcelable
		 */
      	public static final Parcelable.Creator<SavedState> CREATOR = new Parcelable.Creator<SavedState>() {
    	  	public SavedState createFromParcel(Parcel in) {
    	  		return new SavedState(in);
        	}

        	public SavedState[] newArray(int size) {
        		return new SavedState[size];
        	}
      	};
    }

}